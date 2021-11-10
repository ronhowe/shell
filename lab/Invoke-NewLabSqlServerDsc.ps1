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
    $WindowsServerIsoPath,
    
    [Parameter(Mandatory = $true)]
    [string]
    $SqlServerIsoPath
)

& "$PSScriptRoot/Invoke-NewLabBaseServerDsc.ps1" -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath

$ProgressPreference = "SilentlyContinue"

Configuration "NewLabSqlServerDsc" {
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
        $WindowsServerIsoPath,
    
        [Parameter(Mandatory = $true)]
        [string]
        $SqlServerIsoPath
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {
        xVMDvdDrive NewVMDvdDriveISO {
            Ensure             = "Present"
            VMName             = $VMName
            ControllerNumber   = 1
            ControllerLocation = 1
            Path               = $SqlServerIsoPath
        }
    }
}

NewLabSqlServerDsc -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath -SqlServerIsoPath $SqlServerIsoPath -OutputPath "$env:TEMP/NewLabSqlServerDsc"

Start-DscConfiguration -Path "$env:TEMP/NewLabSqlServerDsc" -Wait -Verbose
