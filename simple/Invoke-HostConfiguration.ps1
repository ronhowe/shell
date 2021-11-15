#requires -RunAsAdministrator
#requires -PSEdition Core

Push-Location -Path $PSScriptRoot

$ScriptBlock = {
    . ".\HostConfiguration.ps1"

    HostConfiguration -ConfigurationData ".\HostConfiguration.psd1" -OutputPath "$env:TEMP\HostConfiguration"
    
    Start-DscConfiguration -Path "$env:TEMP\HostConfiguration" -Force -Wait -Verbose
}

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    $ScriptBlock
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait

Pop-Location
