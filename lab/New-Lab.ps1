#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot/New-LabDomainServer.ps1"
& "$PSScriptRoot/New-LabSqlServer.ps1"
& "$PSScriptRoot/New-LabWebServer.ps1"
