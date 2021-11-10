#requires -RunAsAdministrator
#requires -PSEdition Desktop

param(
    [Parameter(Mandatory = $true)]
    [string]
    $VMName,

    [Parameter(Mandatory = $true)]
    [string]
    $VirtualHardDisksPath,

    [Parameter(Mandatory = $true)]
    [string]
    $WindowsServerIsoPath
)

$ProgressPreference = "SilentlyContinue"

Configuration "NewLabBaseServerDsc" {
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $VMName,
    
        [Parameter(Mandatory = $true)]
        [string]
        $VirtualHardDisksPath,
    
        [Parameter(Mandatory = $true)]
        [string]
        $WindowsServerIsoPath
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {
        xVHD $VMName {
            Name             = $VMName
            Ensure           = "Present"
            Path             = $VirtualHardDisksPath
            Generation       = "VHDX"
            MaximumSizeBytes = 50GB
        }
        xVMHyperV $VMName {
            Name                        = $VMName
            Ensure                      = "Present"
            DependsOn                   = "[xVHD]$VMName"
            ProcessorCount              = 4
            MinimumMemory               = 4GB
            VhdPath                     = Join-Path -Path $VirtualHardDisksPath -ChildPath "$VMName.vhdx"
            EnableGuestService          = $true
            AutomaticCheckpointsEnabled = $false
            SwitchName                  = "Default Switch"
        }
        xVMDvdDrive NewVMDvdDriveISO {
            Ensure             = "Present"
            VMName             = $VMName
            ControllerNumber   = 1
            ControllerLocation = 0
            Path               = $WindowsServerIsoPath
            DependsOn          = "[xVMHyperV]$VMName"
        }
    }
}

NewLabBaseServerDsc -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath -OutputPath "$env:TEMP\NewLabBaseServerDsc"

Start-DscConfiguration -Path "$env:TEMP\NewLabBaseServerDsc" -Force -Wait -Verbose
