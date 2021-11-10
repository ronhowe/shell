#requires -RunAsAdministrator
#requires -PSEdition Core

& "$PSScriptRoot\Remove-LabBaseServer.ps1" -VMName "DC01" -InvokeDscScriptPath "$PSScriptRoot\Invoke-RemoveLabBaseServerDsc.ps1"
