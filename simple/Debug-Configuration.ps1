Import-Module -Name "Hyper-V"

Set-Location -Path "~\repos\ronhowe\powershell\simple"

$Credential = Get-Credential -Message "Administrator Credential" -Username "Administrator"

.\Invoke-HostConfiguration.ps1 -Verbose

Write-Host "Complete OOBE Setup"

$ComputerNames = @("DC01", "SQL01", "WEB01")

<#
Start-VM -Name "DC01" -Verbose
Start-VM -Name "SQL01" -Verbose
Start-VM -Name "WEB01" -Verbose
#>
$ComputerNames | Start-VM -Verbose

<#
Stop-VM -Name "DC01" -Verbose
Stop-VM -Name "SQL01" -Verbose
Stop-VM -Name "WEB01" -Verbose
#>
$ComputerNames | Stop-VM -Verbose

<#
.\Rename-Guest.ps1 -ComputerName "DC01" -Credential $Credential -Verbose
.\Rename-Guest.ps1 -ComputerName "SQL01" -Credential $Credential -Verbose
.\Rename-Guest.ps1 -ComputerName "WEB01" -Credential $Credential -Verbose
#>
$ComputerNames | .\Rename-Guest.ps1 -Credential $Credential -Verbose

<#
.\Install-GuestDependencies.ps1 -ComputerName "DC01" -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose
.\Install-GuestDependencies.ps1 -ComputerName "SQL01" -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose
.\Install-GuestDependencies.ps1 -ComputerName "WEB01" -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose
#>
$ComputerNames | .\Install-GuestDependencies.ps1 -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose

<#
.\Invoke-GuestConfiguration.ps1 -ComputerName "DC01" -Credential $Credential -Verbose
.\Invoke-GuestConfiguration.ps1 -ComputerName "SQL01" -Credential $Credential -Verbose
.\Invoke-GuestConfiguration.ps1 -ComputerName "WEB01" -Credential $Credential -Verbose
#>
$ComputerNames | .\Invoke-GuestConfiguration.ps1 -Credential $Credential -Verbose
