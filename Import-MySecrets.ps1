#requires -PSEdition Core
#requires -Modules "Microsoft.PowerShell.SecretManagement"
#requires -Modules "Microsoft.PowerShell.SecretStore"

[CmdletBinding()]
param()

. "$PSScriptRoot\Import-MyConfigurations.ps1"

$AdministratorUsername = "Administrator"
$AdministratorPassword = Get-Secret -Name "AdministratorPassword" -Vault $Configuration.SecretVault
[PSCredential]$AdministratorCredential = New-Object System.Management.Automation.PSCredential ($AdministratorUsername, $AdministratorPassword)

$CertificatePassword = Get-Secret -Name "CertificatePassword" -Vault $Configuration.SecretVault

# Suppresses PSScriptAnalyzer(PSUseDeclaredVarsMoreThanAssignments).
@($AdministratorCredential, $CertificatePassword) | Out-Null