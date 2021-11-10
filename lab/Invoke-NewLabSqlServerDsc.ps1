#requires -RunAsAdministrator
#requires -PSEdition Desktop

param(
    [Parameter(Mandatory = $true)]
    [string]
    $VMName,

    [Parameter(Mandatory = $true)]
    [string]
    $VirtualHardDisksPath,

    [Parameter(Mandatory = $true)]
    [string]
    $WindowsServerIsoPath,
    
    [Parameter(Mandatory = $true)]
    [string]
    $SqlServerIsoPath
)

& "$PSScriptRoot\Invoke-NewLabBaseServerDsc.ps1" -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath

$ProgressPreference = "SilentlyContinue"

function Get-SwitchIpAddress {
    return (Get-NetIPConfiguration -InterfaceAlias 'vEthernet (Default Switch)' | Select-Object -ExpandProperty "IPv4Address" | Select-Object -Property "IPAddress").IPAddress
}

function Get-LabDomainServerIpAddress { 
    $IpAddress = $(Get-SwitchIpAddress).Split('.')
    $IpAddress[-1] = 10
    return $IpAddress -join '.'
}

function Get-LabSqlServerIpAddress { 
    $IpAddress = $(Get-SwitchIpAddress).Split('.')
    $IpAddress[-1] = 20
    return $IpAddress -join '.'
}

Configuration "NewLabSqlServerDsc" {
    param
    (
        [Parameter(Mandatory = $true)]
        [string]
        $VMName,
    
        [Parameter(Mandatory = $true)]
        [string]
        $VirtualHardDisksPath,
    
        [Parameter(Mandatory = $true)]
        [string]
        $WindowsServerIsoPath,
    
        [Parameter(Mandatory = $true)]
        [string]
        $SqlServerIsoPath
    )

    Import-DscResource -ModuleName "xHyper-V"

    Node "localhost" {
        # xVMNetworkAdapter $VMName {
        #     Id             = $VMName
        #     Name           = $VMName
        #     Ensure         = "Present"
        #     SwitchName     = "Default Switch"
        #     VMName         = $VMName
        #     NetworkSetting = xNetworkSettings {
        #         IpAddress      = Get-LabSqlServerIpAddress
        #         Subnet         = "255.255.240.0"
        #         DefaultGateway = Get-SwitchIpAddress
        #         DnsServer      = "$(Get-LabDomainServerIpAddress),$(Get-SwitchIpAddress)"
        #     }
        # }
        xVMDvdDrive NewVMDvdDriveISO {
            Ensure             = "Present"
            VMName             = $VMName
            ControllerNumber   = 1
            ControllerLocation = 1
            Path               = $SqlServerIsoPath
        }
    }
}

NewLabSqlServerDsc -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath -SqlServerIsoPath $SqlServerIsoPath -OutputPath "$env:TEMP\NewLabSqlServerDsc"

Start-DscConfiguration -Path "$env:TEMP\NewLabSqlServerDsc" -Wait -Verbose
