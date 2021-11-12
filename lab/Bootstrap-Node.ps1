param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]
    $ComputerName
)

$ProgressPreference = "SilentlyContinue"

& "$PSScriptRoot\Install-DscResources.ps1" -ComputerName $ComputerName -Credential $MyConfiguration.VmAdministratorCredential

& "$PSScriptRoot\Install-DscEncryptionCertificate.ps1" -ComputerName $ComputerName -Credential $MyConfiguration.VmAdministratorCredential -CertificatePfxPath "$env:TEMP\DscPrivateKey.pfx" -CertificatePfxPassword $CertificatePassword

& "$PSScriptRoot\Invoke-LocalConfigurationManagerDsc.ps1" -ComputerName $ComputerName -Credential $MyConfiguration.VmAdministratorCredential -CertificateFile "$env:TEMP\DscPublicKey.cer" -Thumbprint $MyConfiguration.DscEncryptionCertificateThumbprint
