throw "Safety Net"

#############################################################################################################################################################################
#region Secrets

#region Get Secret

$UserName = "Administrator"
$Password = Get-Content -Path "C:\Users\ronhowe\OneDrive\Documents\DevSecOps\secret.txt" | ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserName, $Password

#endregion Get Secret

#endregion Secrets
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Prerequisites

#region Requires Windows PowerShell

if ($PSVersionTable.PSEdition -eq "Desktop") {
    Write-Host "Windows PowerShell OK" -ForegroundColor Green
}
else {
    Write-Error "Requires Windows PowerShell" -ErrorAction Stop
}

#endregion Requires Windows PowerShell

#region Requires Run As Administrator

if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Run As Administrator OK" -ForegroundColor Green
}
else {
    Write-Error "Not running as Administrator." -ErrorAction Stop
}

#endregion Requires Run As Administrator

#region Requires Hyper-V Module

if (Get-Module -Name "Hyper-V" -ListAvailable) {
    Import-Module -Name "Hyper-V"
    Write-Host "Hyper-V Module OK" -ForegroundColor Green
}
else {
    Write-Error "Install Hyper-V Module" -ErrorAction Stop
}

#endregion Requires Hyper-V Module

#region Requires xHyper-V DSC Resource

if (Get-Module -Name "xHyper-V" -ListAvailable) {
    Write-Host "xHyper-V DSC Resource OK" -ForegroundColor Green
}
else {
    Write-Error "Install xHyper-V DSC Resource" -ErrorAction Stop
    # Install-Module -Name "xHyper-V"
}

#endregion Requires xHyper-V DSC Resource

#region Requires Unrestricted Execution Policy

if ((Get-ExecutionPolicy) -eq "Unrestricted") {
    Write-Host "Execution Policy OK" -ForegroundColor Green
}
else {
    Write-Error "Set Execution Policy" -ErrorAction Stop
    # Set-ExecutionPolicy -ExecutionPolicy Unrestricted
}

#endregion Requires Unrestricted Execution Policy

#endregion Prerequisites
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Hyper-V

#region Get Virtual Machines

@("DC01", "SQL01", "WEB01") | Get-VM

#endregion Get Virtual Machines

#region Create Virtual Machines

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
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force -Verbose

CreateVirtualMachines -VMName "SQL01" -IPAddress "172.18.61.5" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force -Verbose

CreateVirtualMachines -VMName "WEB01" -IPAddress "172.18.61.6" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force -Verbose

Pop-Location

#endregion Create Virtual Machines

#region Delete Virtual Machines

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
    Start-DscConfiguration -Path ./DeleteVirtualMachines -Wait -Force -Verbose
}

Pop-Location

#endregion Delete Virtual Machines

#region Start Virtual Machines

@("DC01", "SQL01", "WEB01") | Start-VM

#endregion Start Virtual Machines

#region Stop Virtual Machines

@("DC01", "SQL01", "WEB01") | Stop-VM

#endregion Stop Virtual Machines

#region Create Checkpoints

@("DC01", "SQL01", "WEB01") | Checkpoint-VM -SnapshotName "CORE"

#endregion Create Checkpoints

#region Remove Checkpoints

@("DC01", "SQL01", "WEB01") | ForEach-Object { Remove-VMCheckpoint -VMName $_ -Name "CORE" -Confirm:$false }

#endregion Remove Checkpoints

#endregion Hyper-V
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Windows

#region Rename Computers

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Rename-Computer -NewName $using:_ -Restart -Force -Verbose
    }
}

#endregion Rename Computers

#region Restart Computers

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Restart-Computer -Force -Verbose
    }
}

#endregion Restart Computers

#region Stop Computers

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Stop-Computer -Force -Verbose
    }
}

#endregion Stop Computers

#region Set TimeZone

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Set-TimeZone -Name "Eastern Standard Time" -Verbose
    }
}

#endregion Set TimeZone

#endregion Windows
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Windows Updates

#region Install Prequisites

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Install-PackageProvider -Name "NuGet" -MinimumVersion "2.8.5.201" -Force -Verbose
        Install-Module -Name "PSWindowsUpdate" -Force -Verbose
    }
}

#endregion Install Prequisites

#region Get Windows Updates

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Import-Module -Name "PSWindowsUpdate"
        Get-WindowsUpdate -Verbose | Format-Table -AutoSize
    }
}

#endregion Get Windows Updates

#region Install Windows Updates

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -AsJob -ScriptBlock {
        Import-Module -Name "PSWindowsUpdate"
        Install-WindowsUpdate -AutoReboot -Confirm:$false -Verbose
    }
}

while (Get-Job -State "Running") {
    Write-Host "Waiting 10 second(s) for jobs to complete..." ;
    Start-Sleep -Seconds 10
}

#endregion Install Windows Updates

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

Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses 172.18.61.4, 172.18.48.1

Restart-Computer -Force

Test-NetConnection

Get-NetConnectionProfile

Set-NetConnectionProfile -InterfaceIndex 13 -NetworkCategory Private

Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses 172.18.61.4, 172.18.48.1

Add-Computer -DomainName "LAB.LOCAL" -Restart

#endregion Network
#############################################################################################################################################################################
