#requires -Modules "PowerConfig"

[CmdletBinding()]
param()

# https://github.com/JustinGrote/PowerConfig/blob/main/Demo/PowerConfigDemo.ps1

$PowerConfig = New-PowerConfig

$PowerConfig | Add-PowerConfigJsonSource -Path "$PSScriptRoot/Configuration.json" | Out-Null

$UserConfigurationPath = "$PSScriptRoot/Configuration.user.json"
if (Test-Path -Path $UserConfigurationPath -ErrorAction SilentlyContinue) {
    $PowerConfig | Add-PowerConfigJsonSource -Path $UserConfigurationPath | Out-Null
}

$Configuration = $PowerConfig | Get-PowerConfig

# Suppress PSScriptAnalyzer(PSUseDeclaredVarsMoreThanAssignments)
$Configuration | Out-Null
