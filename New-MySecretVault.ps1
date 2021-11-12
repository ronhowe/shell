#requires -PSEdition Core
#requires -Modules "Microsoft.PowerShell.SecretManagement"
#requires -Modules "Microsoft.PowerShell.SecretStore"

. "$PSScriptRoot\Import-MyConfigurations.ps1"

if (Get-SecretVault -Name $Configuration.SecretVaultName -ErrorAction SilentlyContinue) {
    Unregister-SecretVault -Name $Configuration.SecretVaultName
}

Register-SecretVault -Name $MyConfiguration.SecretVaultName -ModuleName "Microsoft.PowerShell.SecretStore" -DefaultVault

Set-Secret -Name $MyConfiguration.VmAdministratorPassword -Vault $MyConfiguration.SecretVaultName -SecureStringSecret (Read-Host -Prompt "Virtual Machine Administrator Password" -AsSecureString)

# Set-Secret -Name "CertificatePassword" -Vault $MyConfiguration.SecretVaultName -SecureStringSecret $(Read-Host -Prompt "Certificate Password" -AsSecureString)
