throw "Safety Net"

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
Get-Module -Name "Hyper-V" -ListAvailable
Import-Module -Name "Hyper-V"

# Requires xHyper-V DSC Resource
Get-Module -Name "xHyper-V" -ListAvailable
Find-Module -Name "xHyper-V"
Install-Module -Name "xHyper-V"

# Requires Unrestricted Execution Policy
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

#endregion Prerequisites

#region Spin Up

Configuration "SpinUp" {
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

SpinUp -VMName "DC01" -IPAddress "172.18.61.4" -OutputPath ./SpinUp
Start-DscConfiguration -Path ./SpinUp -Verbose -Wait -Force

SpinUp -VMName "SQL01" -IPAddress "172.18.61.5" -OutputPath ./SpinUp
Start-DscConfiguration -Path ./SpinUp -Verbose -Wait -Force

SpinUp -VMName "WEB01" -IPAddress "172.18.61.6" -OutputPath ./SpinUp
Start-DscConfiguration -Path ./SpinUp -Verbose -Wait -Force

Pop-Location

#endregion Spin Up

#region Spin Down

Configuration "SpinDown" {
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
    Stop-VM -VMName $_
    SpinDown -VMName $_ -OutputPath ./SpinDown
    Start-DscConfiguration -Path ./SpinDown -Verbose -Wait -Force
}

Pop-Location

#endregion Spin Down

#region Get Virtual Machines

@("DC01", "SQL01", "WEB01") |
Get-VM

#endregion Get Virtual Machines

#region Stop Virtual Machines

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Stop-VM -Name $_
}

#endregion Stop Virtual Machines

#region Start Virtual Machines

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Start-VM -Name $_
}

#endregion Start Virtual Machines

#region Create Checkpoint

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Checkpoint-VM -Name $_ -SnapshotName "BASE"
}

#endregion Create Checkpoint

#region Remove Checkpoint

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Remove-VMCheckpoint -VMName $_ -Name "BASE" -Confirm:$false
}

#endregion Remove Checkpoint
