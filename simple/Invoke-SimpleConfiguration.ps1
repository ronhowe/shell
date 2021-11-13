#requires -PSEdition Desktop

param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [securestring]
    $Password
)

$ProgressPreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"

Clear-Host

Push-Location -Path $PSScriptRoot

. ".\SimpleConfiguration.ps1"

$Username = "Administrator"

$Credential = New-Object System.Management.Automation.PSCredential ($Username, $Password)

$Session = New-PSSession -ComputerName "DC01" -Credential $Credential

Copy-Item -Path "$env:TEMP\DscPrivateKey.pfx" -Destination "C:\DscPrivateKey.pfx" -ToSession $Session

Invoke-Command -Session $Session -ScriptBlock {
    Import-PfxCertificate -FilePath "C:\DscPrivateKey.pfx" -CertStoreLocation "Cert:\LocalMachine\My" -Password $using:Password
}

$Session | Remove-PSSession

SimpleConfiguration -ConfigurationData ".\SimpleConfiguration.psd1" -OutputPath "$env:TEMP\SimpleConfiguration" -Credential $Credential

Set-DscLocalConfigurationManager -ComputerName "DC01" -Credential $Credential -Path "$env:TEMP\SimpleConfiguration"

Start-DscConfiguration -ComputerName "DC01" -Credential $Credential -Path "$env:TEMP\SimpleConfiguration" -Force -Wait

Pop-Location
