@{
    AllNodes = @(
        @{
            ActionAfterReboot  = "ContinueConfiguration"
            CertificateFile    = "$env:TEMP\DscPublicKey.cer"
            CertificateId      = "788B0ECB7F170CB9D7D8D6FD152AB4DD244E1D59"
            ConfigurationMode  = "ApplyAndAutoCorrect"
            DomainName         = "LAB.LOCAL"
            NodeName           = "*"
            RebootNodeIfNeeded = $true
            RestartCount       = 3
            Subnet             = 20
            TimeZone           = "Eastern Standard Time"
            WaitTimeout        = 60
        },
        @{
            DatabasePath                = "C:\Windows\NTDS"
            LogPath                     = "C:\Windows\NTDS"
            NodeName                    = "DC01"
            SkipCcmClientSDK            = $true
            SkipComponentBasedServicing = $true
            SkipPendingFileRename       = $true
            SkipWindowsUpdate           = $true
            SysvolPath                  = "C:\Windows\SYSVOL"
        };
        @{
            Features            = "SQLENGINE"
            InstanceName        = "MSSQLSERVER"
            NodeName            = "SQL01"
            SourcePath          = "E:\"
            SQLSysAdminAccounts = @("Administrators")
        };
        @{
            NodeName = "WEB01"
        };
    );
}