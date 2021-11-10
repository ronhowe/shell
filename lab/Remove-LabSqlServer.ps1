#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot/Remove-LabBaseServer.ps1" -VMName "SQL01" -InvokeDscScriptPath "$PSScriptRoot/Invoke-RemoveLabBaseServerDsc.ps1"
