#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot\Remove-LabDomainServer.ps1"
& "$PSScriptRoot\Remove-LabSqlServer.ps1"
& "$PSScriptRoot\Remove-LabWebServer.ps1"
