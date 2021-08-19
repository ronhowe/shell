throw "Safety Net"

$Credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

#############################################################################################################################################################################
#region Prerequisites

# Requires Windows PowerShell
if ($PSVersionTable.PSEdition -ne "Desktop") {
    Write-Error "Requires Windows PowerShell" -ErrorAction Stop
}

# Requires Run As Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Not running as Administrator." -ErrorAction Stop
}

# Requires Hyper-V Module
Import-Module -Name "Hyper-V"

# Requires xHyper-V DSC Resource
Install-Module -Name "xHyper-V"

# Requires Unrestricted Execution Policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#endregion Prerequisites
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Hyper-V

# Get Virtual Machine(s)
@("DC01", "SQL01", "WEB01") | Get-VM

#region Create Virtual Machine(s)

Configuration "CreateVirtualMachines" {
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $VMName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $IPAddress
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {

        xVHD $VMName {
            Name             = $VMName
            Ensure           = "Present"
            Path             = "D:\Hyper-V\Virtual Hard Disks"
            Generation       = "VHDX"
            MaximumSizeBytes = 40GB
        }

        xVMHyperV $VMName {
            Name                        = $VMName
            Ensure                      = "Present"
            DependsOn                   = "[xVHD]$VMName"
            ProcessorCount              = 4
            MinimumMemory               = 4GB
            VhdPath                     = "D:\Hyper-V\Virtual Hard Disks\$VMName.vhdx"
            EnableGuestService          = $true
            AutomaticCheckpointsEnabled = $false
        }

        xVMDvdDrive NewVMDvdDriveISO {
            Ensure             = "Present"
            VMName             = $VMName
            ControllerNumber   = 1
            ControllerLocation = 0
            Path               = "C:\Users\ronhowe\Downloads\Windows Server 2019.iso"
            DependsOn          = "[xVMHyperV]$VMName"
        }
        
        xVMNetworkAdapter $VMName {
            Id             = $VMName
            Name           = $VMName
            Ensure         = "Present"
            DependsOn      = "[xVMHyperV]$VMName"
            SwitchName     = "Default Switch"
            VMName         = $VMName
            NetworkSetting = xNetworkSettings {
                IpAddress      = $IPAddress
                Subnet         = "255.255.240.0"
                DefaultGateway = "172.18.48.1"
                DnsServer      = "172.18.48.1"
            }
        }
    }
}

Push-Location $env:TEMP

CreateVirtualMachines -VMName "DC01" -IPAddress "172.18.61.4" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force

CreateVirtualMachines -VMName "SQL01" -IPAddress "172.18.61.5" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force

CreateVirtualMachines -VMName "WEB01" -IPAddress "172.18.61.6" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force

Pop-Location

#endregion Create Virtual Machine(s)

#region Delete Virtual Machine(s)

Configuration "DeleteVirtualMachines" {
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $VMName
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {

        xVHD $VMName {
            Name             = $VMName
            Ensure           = "Absent"
            Path             = "D:\Hyper-V\Virtual Hard Disks"
            Generation       = "VHDX"
            MaximumSizeBytes = 40GB
        }

        xVMHyperV $VMName {
            Name           = $VMName
            Ensure         = "Absent"
            DependsOn      = "[xVHD]$VMName"
            ProcessorCount = 4
            MinimumMemory  = 4GB
            VhdPath        = "D:\Hyper-V\Virtual Hard Disks\$VMName.vhdx"
        }
    }
}

Push-Location $env:TEMP

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    DeleteVirtualMachines -VMName $_ -OutputPath ./DeleteVirtualMachines
    Start-DscConfiguration -Path ./DeleteVirtualMachines -Wait -Force
}

Pop-Location

#endregion Delete Virtual Machine(s)

# Start Virtual Machine(s)
@("DC01", "SQL01", "WEB01") | Start-VM

# Stop Virtual Machine(s)
@("DC01", "SQL01", "WEB01") | Stop-VM

# Create Checkpoint(s)
@("DC01", "SQL01", "WEB01") | Checkpoint-VM -SnapshotName "CORE"

# Remove Checkpoint(s)
@("DC01", "SQL01", "WEB01") | ForEach-Object { Remove-VMCheckpoint -VMName $_ -Name "CORE" -Confirm:$false }

#endregion Hyper-V
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Windows

# Rename Computer(s)
@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -AsJob -ScriptBlock {
        Rename-Computer -NewName $using:_ -Restart -Force
    }
}

# Set TimeZone
@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -ComputerName $_ -Credential $Credential -AsJob -ScriptBlock {
        Set-TimeZone -Name "Eastern Standard Time"
    }
}

#endregion Windows
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Windows Updates

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -ComputerName $_ -Credential $Credential -AsJob -ScriptBlock {
        Install-PackageProvider -Name "NuGet" -MinimumVersion "2.8.5.201" -Force
        Install-Module -Name "PSWindowsUpdate" -Force
        Get-WindowsUpdate
        Install-WindowsUpdate -AutoReboot -Confirm:$false
    }
}

#endregion Windows Updates
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Network

Enter-PSSession -VMName "WEB01"

Get-NetIPConfiguration

# Microsoft Hyper-V Network Adapter

Get-NetIPConfiguration | Where-Object { $_.InterfaceDescription -eq "Microsoft Hyper-V Network Adapter" }

Get-NetIPConfiguration | Where-Object { $_.InterfaceDescription -eq "Microsoft Hyper-V Network Adapter" } -OutVariable Interface

$Interface

ipconfig

New-NetIPAddress -InterfaceIndex 3 -IPAddress 172.18.61.10 -PrefixLength 20 -DefaultGateway 172.18.48.1

Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses 172.18.61.4,172.18.48.1

Restart-Computer -Force

Test-NetConnection

Get-NetConnectionProfile

Set-NetConnectionProfile -InterfaceIndex 13 -NetworkCategory Private

Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses 172.18.61.4,172.18.48.1

Add-Computer -DomainName "LAB.LOCAL" -Restart

#endregion Network
#############################################################################################################################################################################
