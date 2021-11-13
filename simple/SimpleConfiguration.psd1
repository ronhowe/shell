@{
    AllNodes = @(
        @{
            NodeName        = "*"
            CertificateFile = "$env:TEMP\DscPublicKey.cer"
            Thumbprint      = "788B0ECB7F170CB9D7D8D6FD152AB4DD244E1D59"
        },
        @{
            NodeName      = "DC01"
            SimpleMessage = "SimpleMessage"
        };
    );
}