param (
    [string]
    $ComputerName,

    [PSCredential]
    $Credential
)

$ProgressPreference = "SilentlyContinue"

Write-Verbose "Importing Configuration"
. ".\GuestConfiguration.ps1"

Write-Verbose "Compiling Configuration"
GuestConfiguration -ConfigurationData ".\GuestConfiguration.psd1" -OutputPath "$env:TEMP\GuestConfiguration" -Credential $Credential

Write-Verbose "Setting Local Configuration Manager"
Set-DscLocalConfigurationManager -ComputerName $ComputerName -Credential $Credential -Path "$env:TEMP\GuestConfiguration" -Verbose

Write-Verbose "Starting Configuration"
Start-DscConfiguration -ComputerName $ComputerName -Credential $Credential -Path "$env:TEMP\GuestConfiguration" -Force -Wait -Verbose
