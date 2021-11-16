@{
    AllNodes = @(
        @{
            ActionAfterReboot  = "ContinueConfiguration"
            CertificateFile    = "$env:TEMP\DscPublicKey.cer"
            ConfigurationMode  = "ApplyAndAutoCorrect"
            NodeName           = "*"
            RebootNodeIfNeeded = $true
            RestartCount       = 3
            Thumbprint         = "788B0ECB7F170CB9D7D8D6FD152AB4DD244E1D59"
            TimeZone           = "Eastern Standard Time"
            WaitTimeout        = 60
            GatewayIPAddress   = "172.22.80.1"
        },
        @{
            IPAddress                   = "172.22.80.10/20"
            NodeName                    = "DC01"
            PrimaryDnsIPAddress         = "172.22.80.10"
            DomainName                  = "LAB.LOCAL"
            DatabasePath                = "C:\Windows\NTDS"
            LogPath                     = "C:\Windows\NTDS"
            SysvolPath                  = "C:\Windows\SYSVOL"
            SkipCcmClientSDK            = $true
            SkipComponentBasedServicing = $true
            SkipPendingFileRename       = $true
            SkipWindowsUpdate           = $true
        };
        @{
            NodeName            = "SQL01"
            SourcePath          = "E:\"
            Features            = "SQLENGINE"
            InstanceName        = "MSSQLSERVER"
            SQLSysAdminAccounts = @("Administrators")
        };
        @{
            NodeName = "WEB01"
        };
    );
}