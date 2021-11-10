param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]
    $ComputerName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [PSCredential]
    $Credential,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]
    $CertificatePfxPath,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [securestring]
    $CertificatePfxPassword
)

$ProgressPreference = "SilentlyContinue"

$Session = New-PSSession -ComputerName $ComputerName -Credential $Credential

Copy-Item -Path $CertificatePfxPath -Destination "C:\DscPrivateKey.pfx" -ToSession $Session

Invoke-Command -Session $Session -ScriptBlock {
    Import-PfxCertificate -FilePath "C:\DscPrivateKey.pfx" -CertStoreLocation "Cert:\LocalMachine\My" -Password $using:CertificatePfxPassword
}

$Session | Remove-PSSession
