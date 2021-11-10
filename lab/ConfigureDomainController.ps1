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
    $Credential
)

$ConfigData = @{
    AllNodes = @(
        @{
            NodeName        = $ComputerName
            CertificateFile = "$env:TEMP/DscPublicKey.cer"
            Thumbprint      = "A7FEA9E7E7C55B876FD563B3D4F7DD8EB60B98FF"
        };
    );
}

function Get-SwitchIpAddress {
    return (Get-NetIPConfiguration -InterfaceAlias "vEthernet (Default Switch)" | Select-Object -ExpandProperty "IPv4Address" | Select-Object -Property "IPAddress").IPAddress
}

function Get-LabDomainServerIpAddress { 
    $IpAddress = $(Get-SwitchIpAddress).Split('.')
    $IpAddress[-1] = 10
    return $IpAddress -join '.'
}

$ProgressPreference = "SilentlyContinue"

# Invoke-Command -VMName $ComputerName -Credential $Credential -ScriptBlock {
#     Install-PackageProvider -Name "Nuget" -Force
#     Install-Module -Name "ActiveDirectoryDsc" -Force
#     Install-Module -Name "ActiveDirectoryCSDsc" -Force
#     Install-Module -Name "ComputerManagementDsc" -Force
#     Install-Module -Name "NetworkingDsc" -Force
# }

Configuration "ConfigureDomainController" {
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "ActiveDirectoryDsc"
    Import-DscResource -ModuleName "ActiveDirectoryCSDsc"
    Import-DscResource -ModuleName "ComputerManagementDsc"
    Import-DscResource -ModuleName "NetworkingDsc"

    Node "DC01" {
        Computer NewName {
            Name = $ComputerName
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
            IPAddress      = "172.18.32.10/20" # 255.255.240.0
            InterfaceAlias = "Ethernet"
            AddressFamily  = "IPV4"
        }

        NetConnectionProfile SetPrivate {
            InterfaceAlias  = "Ethernet"
            NetworkCategory = "Private"
        }
        
        DefaultGatewayAddress SetDefaultGateway {
            Address        = "172.18.32.1"
            InterfaceAlias = "Ethernet"
            AddressFamily  = "IPv4"
        }

        DnsServerAddress PrimaryAndSecondary {
            Address        = "172.18.32.10", "172.18.32.1"
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
                
        WindowsFeatureSet "InstallActiveDirectoryCertificateServices" {
            Name      = @("AD-Certificate", "ADCS-Cert-Authority", "ADCS-Web-Enrollment", "ADCS-Enroll-Web-Pol", "ADCS-Enroll-Web-Svc", "RSAT-ADCS", "RSAT-ADCS-Mgmt")
            Ensure    = "Present"
            DependsOn = "[WaitForADDomain]WaitForActiveDirectory"
        }
                
        AdcsCertificationAuthority "ConfigureADCSCertificationAuthority" {
            IsSingleInstance = "Yes"
            Credential       = $Credential
            CAType           = "EnterpriseRootCA"
            Ensure           = "Present"
            DependsOn        = "[WindowsFeatureSet]InstallActiveDirectoryCertificateServices"
        }
                
        AdcsWebEnrollment "ConfigureADCSWebEnrollment" {
            IsSingleInstance = "Yes"
            Credential       = $Credential
            Ensure           = "Present"
            DependsOn        = "[AdcsCertificationAuthority]ConfigureADCSCertificationAuthority"
        }
    }
}

ConfigureDomainController -ConfigurationData $ConfigData -Credential $Credential -OutputPath "$env:TEMP/ConfigureDomainController"

$CimSession = New-CimSession -ComputerName $ComputerName -Credential $Credential

Start-DscConfiguration -CimSession $CimSession -Path "$env:TEMP/ConfigureDomainController" -Wait -Force -Verbose
