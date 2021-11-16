$Credential = Get-Credential -Message "Administrator Credential" -Username "Administrator"

.\Invoke-HostConfiguration.ps1

$ComputerNames = @("DC01","SQL01","WEB01")

$ComputerNames | .\Rename-Guest.ps1 -Credential $Credential -Verbose

$ComputerNames | .\Install-GuestDependencies.ps1 -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose

$ComputerNames | .\Invoke-GuestConfiguration.ps1 -Credential $Credential -Verbose
