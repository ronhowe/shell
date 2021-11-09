#requires -Modules "Microsoft.PowerShell.SecretManagement"
#requires -Modules "Microsoft.PowerShell.SecretStore"

[CmdletBinding()]
param()

. "$PSScriptRoot\Import-Configuration.ps1"

$AdministratorPassword = Get-Secret -Name "AdministratorPassword" -Vault $Configuration.SecretVault

# Suppress PSScriptAnalyzer(PSUseDeclaredVarsMoreThanAssignments)
$AdministratorPassword | Out-Null
