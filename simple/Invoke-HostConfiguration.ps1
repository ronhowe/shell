#requires -RunAsAdministrator
#requires -PSEdition Core

Push-Location -Path $PSScriptRoot

$ScriptBlock = {
    . ".\HostConfiguration.ps1"

    HostConfiguration -ConfigurationData ".\HostConfiguration.psd1" -OutputPath "$env:TEMP\HostConfiguration"
    
    Start-DscConfiguration -Path "$env:TEMP\HostConfiguration" -Force -Wait -Verbose
}

Start-Process -FilePath "powershell.exe" -ArgumentList @("-NoLogo", "-NoProfile", $ScriptBlock) -NoNewWindow -Wait

Pop-Location
