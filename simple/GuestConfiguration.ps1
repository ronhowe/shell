#requires -PSEdition Desktop

Configuration GuestConfiguration {
    param(
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $Credential
    )
    
    #region DSC Resources
    Import-DscResource -ModuleName "ActiveDirectoryCSDsc"
    Import-DscResource -ModuleName "ActiveDirectoryDsc"
    Import-DscResource -ModuleName "ComputerManagementDsc"
    Import-DscResource -ModuleName "NetworkingDsc"
    Import-DscResource -ModuleName "PSDscResources"
    Import-DscResource -ModuleName "SqlServerDsc"
    #endregion DSC Resources

    #region All Nodes
    Node $AllNodes.NodeName {
        # https://docs.microsoft.com/en-us/powershell/scripting/dsc/managing-nodes/metaConfig?view=powershell-7.2
        LocalConfigurationManager {
            ActionAfterReboot  = $Node.ActionAfterReboot
            CertificateId      = $Node.Thumbprint
            ConfigurationMode  = $Node.ConfigurationMode
            RebootNodeIfNeeded = $Node.RebootNodeIfNeeded
        }
        Computer NewName {
            Name = $AllNodes.NodeName
        }
        TimeZone TimeZoneExample {
            IsSingleInstance = "Yes"
            TimeZone         = $Node.TimeZone
        }
        NetIPInterface DisableDhcp {
            AddressFamily  = "IPv4"
            Dhcp           = "Disabled"
            InterfaceAlias = "Ethernet"
        }
        IPAddress NewIPv4Address {
            AddressFamily  = "IPV4"
            InterfaceAlias = "Ethernet"
            IPAddress      = $Node.IPAddress
        }
        NetConnectionProfile SetPrivate {
            InterfaceAlias  = "Ethernet"
            NetworkCategory = "Private"
        }
        DefaultGatewayAddress SetDefaultGateway {
            Address        = $Node.GatewayIPAddress
            AddressFamily  = "IPv4"
            InterfaceAlias = "Ethernet"
        }
    }
    #endregion All Nodes

    #region Domain Server
    Node "DC01" {
        DnsServerAddress PrimaryAndSecondary {
            Address        = $Node.PrimaryDnsIPAddress, $Node.GatewayIPAddress
            AddressFamily  = "IPv4"
            InterfaceAlias = "Ethernet"
            Validate       = $false
        }
        WindowsFeature "InstallActiveDirectoryServices" {
            Ensure = "Present"
            Name   = "AD-Domain-Services"
        }
        WindowsFeature "InstallActiveDirectoryTools" {
            DependsOn = "[WindowsFeature]InstallActiveDirectoryServices"
            Ensure    = "Present"
            Name      = "RSAT-ADDS"
        }
        ADDomain "ConfigureActiveDirectory" {
            Credential                    = $Credential
            DatabasePath                  = $Node.DatabasePath
            DependsOn                     = "[WindowsFeature]InstallActiveDirectoryServices"
            DomainName                    = $Node.DomainName
            LogPath                       = $Node.LogPath
            SafemodeAdministratorPassword = $Credential
            SysvolPath                    = $Node.SysvolPath
        }
        PendingReboot RebootAfterConfigureActiveDirectory {
            DependsOn                   = "[ADDomain]ConfigureActiveDirectory"
            Name                        = "RebootAfterConfigureActiveDirectory"
            SkipCcmClientSDK            = $Node.SkipCcmClientSDK
            SkipComponentBasedServicing = $Node.SkipComponentBasedServicing
            SkipPendingFileRename       = $Node.SkipPendingFileRename
            SkipWindowsUpdate           = $Node.SkipWindowsUpdate
        }
        WaitForADDomain "WaitForActiveDirectory" {
            Credential   = $Credential
            DomainName   = $Node.DomainName
            RestartCount = $Node.RestartCount
            WaitTimeout  = $Node.RestartCount
        }
        ADOptionalFeature "EnableActiveDirectoryRecycleBin" {
            DependsOn                         = "[WaitForADDomain]WaitForActiveDirectory"
            EnterpriseAdministratorCredential = $Credential
            FeatureName                       = "Recycle Bin Feature"
            ForestFQDN                        = $Node.DomainName
        }
        # WindowsFeature "InstallActiveDirectoryCertificateServices" {
        #     Name      = @("AD-Certificate", "ADCS-Cert-Authority", "ADCS-Web-Enrollment", "ADCS-Enroll-Web-Pol", "ADCS-Enroll-Web-Svc", "RSAT-ADCS", "RSAT-ADCS-Mgmt")
        #     Ensure    = "Present"
        #     DependsOn = "[WaitForADDomain]WaitForActiveDirectory"
        # }
        # AdcsCertificationAuthority "ConfigureADCSCertificationAuthority" {
        #     IsSingleInstance = "Yes"
        #     Credential       = $Credential
        #     CAType           = "EnterpriseRootCA"
        #     Ensure           = "Present"
        #     DependsOn        = "[WindowsFeatureSet]InstallActiveDirectoryCertificateServices"
        # }
        # AdcsWebEnrollment "ConfigureADCSWebEnrollment" {
        #     IsSingleInstance = "Yes"
        #     Credential       = $Credential
        #     Ensure           = "Present"
        #     DependsOn        = "[AdcsCertificationAuthority]ConfigureADCSCertificationAuthority"
        # }
    }
    #endregion Domain Server

    #region SQL Server
    Node "SQL01" {
        SqlSetup "InstallSqlServer" {
            # DependsOn           = "[WindowsFeature]NetFramework45"
            Features            = $Node.Features
            InstanceName        = $Node.InstanceName
            SourcePath          = $Node.SourePath
            SQLSysAdminAccounts = $Node.SQLSysAdminAccounts
        }
    }
    #endregion SQL Server
    
    #region Web Server
    Node "WEB01" {
    }
    #endregion Web Server
}
