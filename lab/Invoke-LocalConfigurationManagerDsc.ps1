#requires -RunAsAdministrator
#requires -PSEdition Desktop

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
    $CertificateFile,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]
    $Thumbprint
)

$ConfigurationData = @{
    AllNodes = @(
        @{
            NodeName        = $ComputerName
            CertificateFile = $CertificateFile
            Thumbprint      = $Thumbprint
        };
    );
}

Configuration LocalConfigurationManagerDsc
{
    Node $AllNodes.NodeName
    {
        LocalConfigurationManager {
            CertificateId = $node.Thumbprint
        }
    }
}

LocalConfigurationManagerDsc -ConfigurationData $ConfigurationData -OutputPath "$env:TEMP\LocalConfigurationManagerDsc"

Set-DscLocalConfigurationManager "$env:TEMP\LocalConfigurationManagerDsc" -ComputerName $ComputerName -Credential $Credential
