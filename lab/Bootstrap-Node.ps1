param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]
    $ComputerName
)

$ProgressPreference = "SilentlyContinue"

& "$PSScriptRoot\Install-DscResources.ps1" -ComputerName $ComputerName -Credential $AdministratorCredential

& "$PSScriptRoot\Install-DscEncryptionCertificate.ps1" -ComputerName $ComputerName -Credential $AdministratorCredential -CertificatePfxPath "$env:TEMP\DscPrivateKey.pfx" -CertificatePfxPassword $CertificatePassword

& "$PSScriptRoot\Invoke-LocalConfigurationManagerDsc.ps1" -ComputerName $ComputerName -Credential $AdministratorCredential -CertificateFile "$env:TEMP\DscPublicKey.cer" -Thumbprint $Configuration.DscEncryptionCertificateThumbprint
