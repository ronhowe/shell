#region Safety Net
throw
#endregion Safety Net

#region Depencencies
Import-Module -Name "Hyper-V"
Import-Module -Name "Pester"
#endregion Depencencies

#region Helpers
Set-Location -Path "~\repos\ronhowe\powershell\lab"
$Credential = Get-Credential -Message "Enter Administrator Credential" -Username "Administrator"
$ComputerNames = @("DC01", "SQL01", "WEB01")
#endregion Helpers

#region Create VM
.\Invoke-HostConfiguration.ps1 -Ensure "Present" -Verbose
#endregion Create VM

#region Delete VM
.\Invoke-HostConfiguration.ps1 -Ensure "Absent" -Verbose
#endregion Delete VM

#region Connect VM
# Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", "DC01")
# Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", "SQL01")
# Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", "WEB01")
$ComputerNames | ForEach-Object { Start-Process -FilePath "vmconnect.exe" -ArgumentList @("localhost", $_) }
#endregion Connect VM

#region Start VM
# Start-VM -Name "DC01" -Verbose
# Start-VM -Name "SQL01" -Verbose
# Start-VM -Name "WEB01" -Verbose
$ComputerNames | Start-VM -Verbose
#endregion Start VM

#region Restart VM
# Restart-VM -Name "DC01" -Verbose
# Restart-VM -Name "SQL01" -Verbose
# Restart-VM -Name "WEB01" -Verbose
$ComputerNames | Start-VM -Verbose
#endregion Restart VM

#region Stop VM
# Stop-VM -Name "DC01" -Verbose
# Stop-VM -Name "SQL01" -Verbose
# Stop-VM -Name "WEB01" -Verbose
$ComputerNames | Stop-VM -Verbose
#endregion Stop VM

#region Snapshot VM
Checkpoint-VM -Name "DC01" -Verbose
Checkpoint-VM -Name "SQL01" -Verbose
Checkpoint-VM -Name "WEB01" -Verbose
$ComputerNames | Checkpoint-VM -Verbose
#endregion Snapshot VM

#region Rename Guest
# .\Rename-Guest.ps1 -ComputerName "DC01" -Credential $Credential -Verbose
# .\Rename-Guest.ps1 -ComputerName "SQL01" -Credential $Credential -Verbose
# .\Rename-Guest.ps1 -ComputerName "WEB01" -Credential $Credential -Verbose
$ComputerNames | .\Rename-Guest.ps1 -Credential $Credential -Verbose
#endregion Rename Guest

#region Install Guest Dependencies
# .\Install-GuestDependencies.ps1 -ComputerName "DC01" -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose
# .\Install-GuestDependencies.ps1 -ComputerName "SQL01" -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose
# .\Install-GuestDependencies.ps1 -ComputerName "WEB01" -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose
$ComputerNames | .\Install-GuestDependencies.ps1 -Credential $Credential -PfxPath "$env:TEMP\DscPrivateKey.pfx" -PfxPassword $Credential.Password -Verbose
#endregion Install Guest Dependencies

#region Invoke Guest Configuration
# .\Invoke-GuestConfiguration.ps1 -ComputerName "DC01" -Credential $Credential -Verbose
# .\Invoke-GuestConfiguration.ps1 -ComputerName "SQL01" -Credential $Credential -Verbose
# .\Invoke-GuestConfiguration.ps1 -ComputerName "WEB01" -Credential $Credential -Verbose
$ComputerNames | .\Invoke-GuestConfiguration.ps1 -Credential $Credential -Verbose
#endregion Invoke Guest Configuration

#region Test Configurations
$ProgressPreference = "SilentlyContinue"
Invoke-Pester -Script .\Test-Configurations.ps1 -Output Detailed
#endregion Test Configurations
