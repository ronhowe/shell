Configuration SimpleConfiguration {
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )
    
    Import-DscResource -ModuleName "PSDscResources"

    Node $AllNodes.NodeName {
        LocalConfigurationManager {
            CertificateId = $node.Thumbprint
        }
    }

    Node "DC01" {
        Log "SimpleLog" {
            Message              = $Node.SimpleMessage
            PsDscRunAsCredential = $Credential
        }
    }
}
