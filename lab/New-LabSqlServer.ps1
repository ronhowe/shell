#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot\New-LabBaseServer.ps1" -VMName "SQL01" -InvokeDscScriptPath "$PSScriptRoot\Invoke-NewLabSqlServerDsc.ps1"
