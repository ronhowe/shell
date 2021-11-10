#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot/New-LabBaseServer.ps1" -VMName "DC01" -InvokeDscScriptPath "$PSScriptRoot/Invoke-NewLabDomainServerDsc.ps1"
