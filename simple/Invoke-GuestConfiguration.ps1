#requires -PSEdition Desktop

[CmdletBinding()]
param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string[]]
    $ComputerName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [PSCredential]
    $Credential
)
begin {
    $ProgressPreference = "SilentlyContinue"

    Push-Location -Path $PSScriptRoot

    Write-Verbose "Importing Configuration"
    . ".\GuestConfiguration.ps1"

    Write-Verbose "Compiling Configuration"
    GuestConfiguration -ConfigurationData ".\GuestConfiguration.psd1" -OutputPath "$env:TEMP\GuestConfiguration" -Credential $Credential
}
process {
    Write-Verbose "Setting Local Configuration Manager"
    Set-DscLocalConfigurationManager -ComputerName $ComputerName -Credential $Credential -Path "$env:TEMP\GuestConfiguration"

    Write-Verbose "Starting Configuration"
    Start-DscConfiguration -ComputerName $ComputerName -Credential $Credential -Path "$env:TEMP\GuestConfiguration" -Force -Wait
}
end {
    Pop-Location
}