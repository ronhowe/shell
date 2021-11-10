#requires -RunAsAdministrator
#requires -PSEdition Desktop

param(
    [string]
    $VMName,

    [string]
    $VirtualHardDisksPath,

    [string]
    $WindowsServerIsoPath
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

Configuration "NewLabDomainServerDsc" {
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
        $WindowsServerIsoPath
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
        #         IpAddress      = Get-LabDomainServerIpAddress
        #         Subnet         = "255.255.240.0"
        #         DefaultGateway = Get-SwitchIpAddress
        #         DnsServer      = Get-SwitchIpAddress
        #     }
        # }
    }
}

NewLabDomainServerDsc -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath -OutputPath "$env:TEMP\NewLabDomainServerDsc"

Start-DscConfiguration -Path "$env:TEMP\NewLabDomainServerDsc" -Wait -Verbose
