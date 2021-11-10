#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot/Remove-LabBaseServer.ps1" -VMName "WEB01" -InvokeDscScriptPath "$PSScriptRoot/Invoke-RemoveLabBaseServerDsc.ps1"
