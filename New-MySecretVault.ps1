#requires -PSEdition Core
#requires -Modules "Microsoft.PowerShell.SecretManagement"
#requires -Modules "Microsoft.PowerShell.SecretStore"

. "$PSScriptRoot\Import-MyConfiguration.ps1"

if (Get-SecretVault -Name $Configuration.SecretVault -ErrorAction SilentlyContinue) {
    Unregister-SecretVault -Name $Configuration.SecretVault
}

Register-SecretVault -Name $Configuration.SecretVault -ModuleName "Microsoft.PowerShell.SecretStore" -DefaultVault

$AdministratorPassword = Read-Host -Prompt "Administrator Password" -AsSecureString
Set-Secret -Name "AdministratorPassword" -Vault $Configuration.SecretVault -SecureStringSecret $AdministratorPassword

$CertificatePassword = Read-Host -Prompt "Certificate Password" -AsSecureString
Set-Secret -Name "CertificatePassword" -Vault $Configuration.SecretVault -SecureStringSecret $CertificatePassword
