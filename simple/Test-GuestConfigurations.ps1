#requires -Modules "Pester"

Clear-Host

$ProgressPreference = "SilentlyContinue"

Push-Location -Path $PSScriptRoot

Invoke-Pester -Script .\TestConfigurations.ps1 -Output Detailed

Pop-Location
