#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot\New-LabBaseServer.ps1" -VMName "WEB01" -InvokeDscScriptPath "$PSScriptRoot\Invoke-NewLabWebServerDsc.ps1"
