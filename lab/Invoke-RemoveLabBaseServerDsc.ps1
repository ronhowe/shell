#requires -RunAsAdministrator
#requires -PSEdition Desktop

param(
    [Parameter(Mandatory = $true)]
    [string]
    $VMName,

    [Parameter(Mandatory = $true)]
    [string]
    $VirtualHardDisksPath
)

$ProgressPreference = "SilentlyContinue"

Configuration "RemoveLabBaseServerDsc" {
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $VMName,
    
        [Parameter(Mandatory = $true)]
        [string]
        $VirtualHardDisksPath
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {
        xVHD $VMName {
            Name             = $VMName
            Ensure           = "Absent"
            Path             = $VirtualHardDisksPath
            Generation       = "VHDX"
            MaximumSizeBytes = 40GB
        }
        xVMHyperV $VMName {
            Name           = $VMName
            Ensure         = "Absent"
            DependsOn      = "[xVHD]$VMName"
            ProcessorCount = 4
            MinimumMemory  = 4GB
            VhdPath        = Join-Path -Path $VirtualHardDisksPath -ChildPath "$VMName.vhdx"
        }
    }
}

RemoveLabBaseServerDsc -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -OutputPath "$env:TEMP\RemoveLabBaseServerDsc"

Start-DscConfiguration -Path "$env:TEMP\RemoveLabBaseServerDsc" -Force -Wait -Verbose
