#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot/Rename-LabDomainServer.ps1"
& "$PSScriptRoot/Rename-LabSqlServer.ps1"
& "$PSScriptRoot/Rename-LabWebServer.ps1"
