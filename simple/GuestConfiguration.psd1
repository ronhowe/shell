@{
    AllNodes = @(
        @{
            ActionAfterReboot  = "ContinueConfiguration"
            CertificateFile    = "$env:TEMP\DscPublicKey.cer"
            ConfigurationMode  = "ApplyAndAutoCorrect"
            DomainName         = "LAB.LOCAL"
            GatewayIPAddress   = "172.22.80.1"
            NodeName           = "*"
            RebootNodeIfNeeded = $true
            RestartCount       = 3
            CertificateId      = "788B0ECB7F170CB9D7D8D6FD152AB4DD244E1D59"
            TimeZone           = "Eastern Standard Time"
            WaitTimeout        = 60
        },
        @{
            IPAddress                   = "172.22.80.10/20"
            NodeName                    = "DC01"
            PrimaryDnsIPAddress         = "172.22.80.10"
            DatabasePath                = "C:\Windows\NTDS"
            LogPath                     = "C:\Windows\NTDS"
            SysvolPath                  = "C:\Windows\SYSVOL"
            SkipCcmClientSDK            = $true
            SkipComponentBasedServicing = $true
            SkipPendingFileRename       = $true
            SkipWindowsUpdate           = $true
        };
        @{
            Features            = "SQLENGINE"
            InstanceName        = "MSSQLSERVER"
            IPAddress           = "172.22.80.20/20"
            NodeName            = "SQL01"
            PrimaryDnsIPAddress = "172.22.80.10"
            SourcePath          = "E:\"
            SQLSysAdminAccounts = @("Administrators")
        };
        @{
            IPAddress           = "172.22.80.30/20"
            NodeName            = "WEB01"
            PrimaryDnsIPAddress = "172.22.80.10"
        };
    );
}