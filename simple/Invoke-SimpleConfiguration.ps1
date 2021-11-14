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

$ComputerName = "DC01"

$Session = New-PSSession -ComputerName $ComputerName -Credential $Credential

Copy-Item -Path "$env:TEMP\DscPrivateKey.pfx" -Destination "C:\DscPrivateKey.pfx" -ToSession $Session

Invoke-Command -Session $Session -ScriptBlock {
    Import-PfxCertificate -FilePath "C:\DscPrivateKey.pfx" -CertStoreLocation "Cert:\LocalMachine\My" -Password $using:Password
}

$Session | Remove-PSSession

Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
    $ProgressPreference = "SilentlyContinue"
    Install-PackageProvider -Name "Nuget" -Force -Verbose | Out-Null
    Install-Module -Name "ActiveDirectoryCSDsc" -Repository "PSGallery" -Force -Verbose
    Install-Module -Name "ActiveDirectoryDsc" -Repository "PSGallery" -Force -Verbose
    Install-Module -Name "ComputerManagementDsc" -Repository "PSGallery" -Force -Verbose
    Install-Module -Name "NetworkingDsc" -Repository "PSGallery" -Force -Verbose
    Install-Module -Name "PSDscResources" -Repository "PSGallery" -Force -Verbose
    Install-Module -Name "SqlServerDsc" -Repository "PSGallery" -Force -Verbose
}

SimpleConfiguration -ConfigurationData ".\SimpleConfiguration.psd1" -OutputPath "$env:TEMP\SimpleConfiguration" -Credential $Credential

Set-DscLocalConfigurationManager -ComputerName $ComputerName -Credential $Credential -Path "$env:TEMP\SimpleConfiguration" -Verbose

Start-DscConfiguration -ComputerName $ComputerName -Credential $Credential -Path "$env:TEMP\SimpleConfiguration" -Force -Wait -Verbose

Pop-Location
