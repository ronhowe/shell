throw "Safety Net"

#############################################################################################################################################################################
#region Secrets

#region Get Secret

$UserName = "Administrator"
$Password = Get-Content -Path "C:\Users\ronhowe\OneDrive\Documents\DevSecOps\secret.txt" |
ConvertTo-SecureString -AsPlainText -Force
$Credential = New-Object -TypeName "System.Management.Automation.PSCredential" -ArgumentList $UserName, $Password

#endregion Get Secret

#endregion Secrets
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Prerequisites

#region Requires Windows PowerShell

if ($PSVersionTable.PSEdition -eq "Desktop") {
    Write-Host "Windows PowerShell OK" -ForegroundColor Green
}
else {
    Write-Error "Requires Windows PowerShell" -ErrorAction Stop
}

#endregion Requires Windows PowerShell

#region Requires Run As Administrator

if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Run As Administrator OK" -ForegroundColor Green
}
else {
    Write-Error "Not running as Administrator." -ErrorAction Stop
}

#endregion Requires Run As Administrator

#region Requires Hyper-V Module

if (Get-Module -Name "Hyper-V" -ListAvailable) {
    Import-Module -Name "Hyper-V"
    Write-Host "Hyper-V Module OK" -ForegroundColor Green
}
else {
    Write-Error "Install Hyper-V Module" -ErrorAction Stop
}

#endregion Requires Hyper-V Module

#region Requires xHyper-V DSC Resource

if (Get-Module -Name "xHyper-V" -ListAvailable) {
    Write-Host "xHyper-V DSC Resource OK" -ForegroundColor Green
}
else {
    Write-Error "Install xHyper-V DSC Resource" -ErrorAction Stop
    # Find-Module -Name "xHyper-V"
    # Install-Module -Name "xHyper-V" -Force
}

#endregion Requires xHyper-V DSC Resource

#region Requires ActiveDirectoryDsc DSC Resource

if (Get-Module -Name "ActiveDirectoryDsc" -ListAvailable) {
    Write-Host "ActiveDirectoryDsc DSC Resource OK" -ForegroundColor Green
}
else {
    Write-Error "Install ActiveDirectoryDsc DSC Resource" -ErrorAction Stop
    # Find-Module -Name "ActiveDirectoryDsc"
    # Install-Module -Name "ActiveDirectoryDsc" -Force
}

#endregion Requires ActiveDirectoryDsc DSC Resource

#region Requires ActiveDirectoryCSDsc DSC Resource

if (Get-Module -Name "ActiveDirectoryCSDsc" -ListAvailable) {
    Write-Host "ActiveDirectoryCSDsc DSC Resource OK" -ForegroundColor Green
}
else {
    Write-Error "Install ActiveDirectoryCSDsc DSC Resource" -ErrorAction Stop
    # Find-Module -Name "ActiveDirectoryCSDsc"
    Install-Module -Name "ActiveDirectoryCSDsc" -Force
}

#endregion Requires ActiveDirectoryCSDsc DSC Resource

#region Requires Unrestricted Execution Policy

if ((Get-ExecutionPolicy) -eq "Unrestricted") {
    Write-Host "Execution Policy OK" -ForegroundColor Green
}
else {
    Write-Error "Set Execution Policy" -ErrorAction Stop
    # Set-ExecutionPolicy -ExecutionPolicy Unrestricted
}

#endregion Requires Unrestricted Execution Policy

#endregion Prerequisites
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Hyper-V

#region Get Virtual Machines

@("DC01", "SQL01", "WEB01") | Get-VM

#endregion Get Virtual Machines

#region Create Virtual Machines

Configuration "CreateVirtualMachines" {
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $VMName,

        [Parameter(Mandatory = $true)]
        [System.String]
        $IPAddress,

        [Parameter(Mandatory = $true)]
        [System.String]
        $DnsServer
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {

        xVHD $VMName {
            Name             = $VMName
            Ensure           = "Present"
            Path             = "D:\Hyper-V\Virtual Hard Disks"
            Generation       = "VHDX"
            MaximumSizeBytes = 40GB
        }

        xVMHyperV $VMName {
            Name                        = $VMName
            Ensure                      = "Present"
            DependsOn                   = "[xVHD]$VMName"
            ProcessorCount              = 4
            MinimumMemory               = 4GB
            VhdPath                     = "D:\Hyper-V\Virtual Hard Disks\$VMName.vhdx"
            EnableGuestService          = $true
            AutomaticCheckpointsEnabled = $false
        }

        xVMDvdDrive NewVMDvdDriveISO {
            Ensure             = "Present"
            VMName             = $VMName
            ControllerNumber   = 1
            ControllerLocation = 0
            Path               = "C:\Users\ronhowe\Downloads\Windows Server 2019.iso"
            DependsOn          = "[xVMHyperV]$VMName"
        }
        
        xVMNetworkAdapter $VMName {
            Id             = $VMName
            Name           = $VMName
            Ensure         = "Present"
            DependsOn      = "[xVMHyperV]$VMName"
            SwitchName     = "Default Switch"
            VMName         = $VMName
            NetworkSetting = xNetworkSettings {
                IpAddress      = $IPAddress
                Subnet         = "255.255.240.0"
                DefaultGateway = "172.18.48.1"
                DnsServer      = $DnsServer
            }
        }
    }
}

Push-Location $env:TEMP

CreateVirtualMachines -VMName "DC01" -IPAddress "172.18.61.4" -DnsServer "172.18.48.1" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force -Verbose

CreateVirtualMachines -VMName "SQL01" -IPAddress "172.18.61.5" -DnsServer "172.18.48.1" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force -Verbose

CreateVirtualMachines -VMName "WEB01" -IPAddress "172.18.61.6" -DnsServer "172.18.48.1" -OutputPath ./CreateVirtualMachines
Start-DscConfiguration -Path ./CreateVirtualMachines -Wait -Force -Verbose

Pop-Location

#endregion Create Virtual Machines

#region Delete Virtual Machines

Configuration "DeleteVirtualMachines" {
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        $VMName
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {

        xVHD $VMName {
            Name             = $VMName
            Ensure           = "Absent"
            Path             = "D:\Hyper-V\Virtual Hard Disks"
            Generation       = "VHDX"
            MaximumSizeBytes = 40GB
        }

        xVMHyperV $VMName {
            Name           = $VMName
            Ensure         = "Absent"
            DependsOn      = "[xVHD]$VMName"
            ProcessorCount = 4
            MinimumMemory  = 4GB
            VhdPath        = "D:\Hyper-V\Virtual Hard Disks\$VMName.vhdx"
        }
    }
}

Push-Location $env:TEMP

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    DeleteVirtualMachines -VMName $_ -OutputPath ./DeleteVirtualMachines
    Start-DscConfiguration -Path ./DeleteVirtualMachines -Wait -Force -Verbose
}

Pop-Location

#endregion Delete Virtual Machines

#region Start Virtual Machines

@("DC01", "SQL01", "WEB01") |
Start-VM

#endregion Start Virtual Machines

#region Stop Virtual Machines

@("DC01", "SQL01", "WEB01") |
Stop-VM -Force

#endregion Stop Virtual Machines

#region Create Checkpoints

@("DC01", "SQL01", "WEB01") |
Checkpoint-VM -SnapshotName "CORE"

#endregion Create Checkpoints

#region Restore Checkpoints

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Restore-VMSnapshot -VMName $_ -Name "CORE" -Confirm:$false
}

#endregion Restore Checkpoints

#region Remove Checkpoints

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Remove-VMCheckpoint -VMName $_ -Name "CORE" -Confirm:$false
}

#endregion Remove Checkpoints

#endregion Hyper-V
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Windows

#region Rename Computers

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Rename-Computer -NewName $using:_ -Restart -Force -Verbose
    }
}

#endregion Rename Computers

#region Restart Computers

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Restart-Computer -Force -Verbose
    }
}

#endregion Restart Computers

#region Stop Computers

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Stop-Computer -Force -Verbose
    }
}

#endregion Stop Computers

#region Set TimeZone

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Set-TimeZone -Name "Eastern Standard Time" -Verbose
    }
}

#endregion Set TimeZone

#endregion Windows
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Windows Updates

#region Install Prequisites

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Install-PackageProvider -Name "NuGet" -MinimumVersion "2.8.5.201" -Force -Verbose
        Install-Module -Name "PSWindowsUpdate" -Force -Verbose
    }
}

#endregion Install Prequisites

#region Get Windows Updates

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Import-Module -Name "PSWindowsUpdate"
        Get-WindowsUpdate -Verbose | Format-Table -AutoSize
    }
}

#endregion Get Windows Updates

#region Install Windows Updates

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -AsJob -ScriptBlock {
        Import-Module -Name "PSWindowsUpdate"
        Install-WindowsUpdate -AutoReboot -Confirm:$false -Verbose
    }
}

while (Get-Job -State "Running") {
    Write-Host "Waiting 10 second(s) for jobs to complete..." ;
    Start-Sleep -Seconds 10
}

#endregion Install Windows Updates

#endregion Windows Updates
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Network

#region Test Net Connection

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Test-NetConnection
    }
}

#endregion Test Net Connection

#region Get Net Configuration

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Get-NetAdapter -InterfaceDescription "Microsoft Hyper-V Network Adapter" |
        Get-NetIPConfiguration
    }
}

#endregion Get Net Configuration

#region Get DNS Configuration

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Get-NetAdapter -InterfaceDescription "Microsoft Hyper-V Network Adapter" |
        Get-DnsClientServerAddress -AddressFamily IPv4
    }
}

#endregion Get DNS Configuration

#region Set DNS Configuration

# TODO
# Set-DnsClientServerAddress -InterfaceIndex 6 -ServerAddresses 172.18.61.4, 172.18.48.1
# Restart-Computer -Force

#endregion Set DNS Configuration

#region Get Net Connection Profile

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Get-NetAdapter -InterfaceDescription "Microsoft Hyper-V Network Adapter"  |
        Get-NetConnectionProfile
    }
}

#endregion Get Net Connection Profile

#region Set Net Connection Profile

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -ScriptBlock {
        Get-NetAdapter -InterfaceDescription "Microsoft Hyper-V Network Adapter"  |
        Set-NetConnectionProfile -NetworkCategory Private -Verbose
    }
}

#endregion Set Net Connection Profile

#endregion Network
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Active Directory

Configuration "ConfigureDomainController" {
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credential
    )

    Import-DscResource -ModuleName "PSDesiredStateConfiguration"
    Import-DscResource -ModuleName "ActiveDirectoryDsc"
    Import-DscResource -ModuleName "ActiveDirectoryCSDsc"

    Node "DC01" {
        # Installs Active Directory.
        WindowsFeature "InstallActiveDirectoryServices" {
            Ensure = "Present"
            Name   = "AD-Domain-Services"
        }

        # Installs Active Directory tools.
        WindowsFeature "InstallActiveDirectoryTools" {
            Ensure    = "Present"
            Name      = "RSAT-ADDS"
            DependsOn = "[WindowsFeature]InstallActiveDirectoryServices"
        }

        # Configures Active Directory.
        ADDomain "ConfigureActiveDirectory" {
            DomainName                    = "LAB.LOCAL"
            Credential                    = $Credential
            SafemodeAdministratorPassword = $Credential
            DatabasePath                  = "C:\Windows\NTDS"
            LogPath                       = "C:\Windows\NTDS"
            SysvolPath                    = "C:\Windows\SYSVOL"
            DependsOn                     = @("[WindowsFeature]InstallActiveDirectoryServices", "[WindowsFeature]InstallActiveDirectoryServices")
        }

        #region TODO
        # Reboots the node after configuring Active Directory in order to complete promotion as a domain controller.
        # This is done with a custom script instead of PendingReboot because (for some reason) a domain controller
        # will DSC reboot via xPendingUpdate when a patch is installed or pending reboot from an install even if
        # $SkipWindowsUpdate is set to $true.
        # $DomainControllerRebootedPostPromotionValueName = Resolve-DscConfigurationProperty -Node $Node -PropertyName "DomainControllerRebootedPostPromotionValueName"
        # $DomainControllerRebootedPostPromotionValueType = Resolve-DscConfigurationProperty -Node $Node -PropertyName "DomainControllerRebootedPostPromotionValueType"
        # $DomainControllerRebootedPostPromotionValueValue = Resolve-DscConfigurationProperty -Node $Node -PropertyName "DomainControllerRebootedPostPromotionValueValue"
        # Script "RebootAfterPromotion" {
        #     GetScript  = {
        #         $Result = Get-ItemPropertyValue -Path $using:IdiDscRegistryKeyPath -Name $using:DomainControllerRebootedPostPromotionValueName
        #         return @{ Result = "$($using:DomainControllerRebootedPostPromotionValueName) : $Result" };
        #     }
        #     SetScript  = {
        #         if (-not (Test-Path -Path $using:IdiDscRegistryKeyPath)) {
        #             New-Item -Path $using:IdiDscRegistryKeyPath -Force | Out-Null
        #         }
        #         New-ItemProperty -Path $using:IdiDscRegistryKeyPath -Name $using:DomainControllerRebootedPostPromotionValueName -Value $using:DomainControllerRebootedPostPromotionValueValue -PropertyType $($using:DomainControllerRebootedPostPromotionValueType).ToUpper() -Force | Out-Null
        #         [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSAvoidGlobalVars", "")]
        #         $global:DSCMachineStatus = 1
        #     }
        #     TestScript = {
        #         if (Test-Path -Path $using:IdiDscRegistryKeyPath) {
        #             $Item = Get-ItemProperty -Path $using:IdiDscRegistryKeyPath -Name $using:DomainControllerRebootedPostPromotionValueName -ErrorAction "SilentlyContinue"
        #             if ($Item) {
        #                 $Value = Get-ItemPropertyValue -Path $using:IdiDscRegistryKeyPath -Name $using:DomainControllerRebootedPostPromotionValueName
        #                 if ($Value -eq $using:DomainControllerRebootedPostPromotionValueValue) {
        #                     return $true
        #                 }
        #             }
        #         }
        #         return $false
        #     }
        #     DependsOn  = "[ADDomain]ConfigureActiveDirectory"
        # }
                
        # # Waits for Active Directory to become available.
        # WaitForADDomain "WaitForActiveDirectory" {
        #     DomainName   = "LAB.LOCAL"
        #     Credential   = $Credential
        #     RestartCount = 3
        #     WaitTimeout  = 60
        # }
                
        # # Enables the Active Directory recycle bin.
        # ADOptionalFeature "EnableActiveDirectoryRecycleBin" {
        #     FeatureName                       = "Recycle Bin Feature"
        #     EnterpriseAdministratorCredential = $Credential
        #     ForestFQDN                        = "LAB.LOCAL"
        #     DependsOn                         = "[WaitForADDomain]WaitForActiveDirectory"
        # }
                
        # # Installs Active Directory Certificate Services.
        # WindowsFeatureSet "InstallActiveDirectoryCertificateServices" {
        #     Name      = @("AD-Certificate", "ADCS-Cert-Authority", "ADCS-Web-Enrollment", "ADCS-Enroll-Web-Pol", "ADCS-Enroll-Web-Svc", "RSAT-ADCS", "RSAT-ADCS-Mgmt")
        #     Ensure    = "Present"
        #     DependsOn = "[WaitForADDomain]WaitForActiveDirectory"
        # }
                
        # # Configures the Active Directory Certificate Services certificate authority.
        # AdcsCertificationAuthority "ConfigureADCSCertificationAuthority" {
        #     IsSingleInstance = "Yes"
        #     Credential       = $Credential
        #     CAType           = "EnterpriseRootCA"
        #     Ensure           = "Present"
        #     DependsOn        = "[WindowsFeatureSet]InstallActiveDirectoryCertificateServices"
        # }
                
        # # Configures the Active Directory Certificate Services web enrollment endpoint.
        # AdcsWebEnrollment "ConfigureADCSWebEnrollment" {
        #     IsSingleInstance = "Yes"
        #     Credential       = $Credential
        #     Ensure           = "Present"
        #     DependsOn        = "[AdcsCertificationAuthority]ConfigureADCSCertificationAuthority"
        # }
        #endregion TODO
    }
}

Push-Location $env:TEMP

ConfigureDomainController -Credential $Credential -OutputPath ./ConfigureDomainController
$CimSession = New-CimSession -ComputerName "DC01" -Credential $Credential
Start-DscConfiguration -CimSession $CimSession -Path ./ConfigureDomainController -Wait -Force -Verbose

Pop-Location

# Add-Computer -DomainName "LAB.LOCAL" -Restart

#endregion Active Directory
#############################################################################################################################################################################
