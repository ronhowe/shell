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

& "$PSScriptRoot\Invoke-NewLabBaseServerDsc.ps1" -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath

$ProgressPreference = "SilentlyContinue"

Configuration "NewLabDomainServerDsc" {
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
    }
}

NewLabDomainServerDsc -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath -OutputPath "$env:TEMP\NewLabDomainServerDsc"

Start-DscConfiguration -Path "$env:TEMP\NewLabDomainServerDsc" -Wait -Verbose
