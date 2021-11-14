#requires -PSEdition Desktop

Configuration SimpleConfiguration {
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )
    
    Import-DscResource -ModuleName "PSDscResources"
    Import-DscResource -ModuleName "ActiveDirectoryDsc"
    Import-DscResource -ModuleName "ActiveDirectoryCSDsc"
    Import-DscResource -ModuleName "ComputerManagementDsc"
    Import-DscResource -ModuleName "NetworkingDsc"

    #region All Nodes
    Node $AllNodes.NodeName {
        # https://docs.microsoft.com/en-us/powershell/scripting/dsc/managing-nodes/metaConfig?view=powershell-7.2
        LocalConfigurationManager {
            CertificateId = $Node.Thumbprint
            ActionAfterReboot = "ContinueConfiguration"
            ConfigurationMode = "ApplyAndAutoCorrect"
            RebootNodeIfNeeded = $true
        }
        Computer NewName {
            Name = $AllNodes.NodeName
        }
        
        TimeZone TimeZoneExample {
            IsSingleInstance = "Yes"
            TimeZone         = "Eastern Standard Time"
        }
        
        NetIPInterface DisableDhcp {
            InterfaceAlias = "Ethernet"
            AddressFamily  = "IPv4"
            Dhcp           = "Disabled"
        }

        IPAddress NewIPv4Address {
            IPAddress      = $Node.IPAddress
            InterfaceAlias = "Ethernet"
            AddressFamily  = "IPV4"
        }

        NetConnectionProfile SetPrivate {
            InterfaceAlias  = "Ethernet"
            NetworkCategory = "Private"
        }
        
        DefaultGatewayAddress SetDefaultGateway {
            Address        = $Node.GatewayIPAddress
            InterfaceAlias = "Ethernet"
            AddressFamily  = "IPv4"
        }

    }
#endregion All Nodes

    Node "DC01" {
        Log "SimpleLog" {
            Message              = $Node.SimpleMessage
            PsDscRunAsCredential = $Credential
        }

        DnsServerAddress PrimaryAndSecondary {
            Address        = $Node.PrimaryDnsIPAddress, $Node.GatewayIPAddress
            InterfaceAlias = "Ethernet"
            AddressFamily  = "IPv4"
            Validate       = $false
        }

        WindowsFeature "InstallActiveDirectoryServices" {
            Ensure = "Present"
            Name   = "AD-Domain-Services"
        }

        WindowsFeature "InstallActiveDirectoryTools" {
            Ensure    = "Present"
            Name      = "RSAT-ADDS"
            DependsOn = "[WindowsFeature]InstallActiveDirectoryServices"
        }

        ADDomain "ConfigureActiveDirectory" {
            DomainName                    = "LAB.LOCAL"
            Credential                    = $Credential
            SafemodeAdministratorPassword = $Credential
            DatabasePath                  = "C:\Windows\NTDS"
            LogPath                       = "C:\Windows\NTDS"
            SysvolPath                    = "C:\Windows\SYSVOL"
            DependsOn                     = "[WindowsFeature]InstallActiveDirectoryServices"
        }

        PendingReboot RebootAfterConfigureActiveDirectory {
            Name                        = 'RebootAfterConfigureActiveDirectory'
            DependsOn                   = "[ADDomain]ConfigureActiveDirectory"
            SkipWindowsUpdate           = $true
            SkipPendingFileRename       = $true
            SkipCcmClientSDK            = $true
            SkipComponentBasedServicing = $true
        }

                
        WaitForADDomain "WaitForActiveDirectory" {
            DomainName   = "LAB.LOCAL"
            Credential   = $Credential
            RestartCount = 3
            WaitTimeout  = 60
        }
                
        ADOptionalFeature "EnableActiveDirectoryRecycleBin" {
            FeatureName                       = "Recycle Bin Feature"
            EnterpriseAdministratorCredential = $Credential
            ForestFQDN                        = "LAB.LOCAL"
            DependsOn                         = "[WaitForADDomain]WaitForActiveDirectory"
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
}
