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

function Get-LabWebServerIpAddress { 
    $IpAddress = $(Get-SwitchIpAddress).Split('.')
    $IpAddress[-1] = 30
    return $IpAddress -join '.'
}

Configuration "LabWebServer" {
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
        #         IpAddress      = Get-LabWebServerIpAddress
        #         Subnet         = "255.255.240.0"
        #         DefaultGateway = Get-SwitchIpAddress
        #         DnsServer      = @((Get-LabDomainServerIpAddress), (Get-SwitchIpAddress))
        #     }
        # }
    }
}

LabWebServer -VMName $VMName -VirtualHardDisksPath $VirtualHardDisksPath -WindowsServerIsoPath $WindowsServerIsoPath -OutputPath "$env:TEMP\LabWebServer"

Start-DscConfiguration -Path "$env:TEMP\LabWebServer" -Wait -Verbose
