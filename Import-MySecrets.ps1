#requires -PSEdition Core
#requires -Modules "Microsoft.PowerShell.SecretManagement"
#requires -Modules "Microsoft.PowerShell.SecretStore"

. "$PSScriptRoot\Import-MyConfigurations.ps1"

$MyConfiguration.VmAdministratorPassword = Get-Secret -Name $MyConfiguration.VmAdministratorPassword -Vault $MyConfiguration.SecretVaultName
$MyConfiguration.VmAdministratorCredential = New-Object System.Management.Automation.PSCredential ($MyConfiguration.VmAdministratorUsername, $MyConfiguration.VmAdministratorPassword)

# $CertificatePassword = Get-Secret -Name "CertificatePassword" -Vault $MyConfiguration.SecretVault
