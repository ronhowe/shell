#requires -Modules "Microsoft.PowerShell.SecretManagement"
#requires -Modules "Microsoft.PowerShell.SecretStore"

[CmdletBinding()]
param()

. "$PSScriptRoot\Import-Configuration.ps1"

if (Get-SecretVault -Name $Configuration.SecretVault -ErrorAction SilentlyContinue) {
    Unregister-SecretVault -Name $Configuration.SecretVault
}

Register-SecretVault -Name $Configuration.SecretVault -ModuleName "Microsoft.PowerShell.SecretStore" -DefaultVault

Get-SecretVault -Name $Configuration.SecretVault

$Password = Read-Host -Prompt "AdministratorPassword" -AsSecureString

Set-Secret -Name "AdministratorPassword" -Vault $Configuration.SecretVault -SecureStringSecret $Password
