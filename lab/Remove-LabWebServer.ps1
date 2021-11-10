#requires -RunAsAdministrator
#requires -PSEdition Core

Get-VM -Name "WEB01" -ErrorAction SilentlyContinue | Stop-VM -ErrorAction SilentlyContinue

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    "$PSScriptRoot\Invoke-RemoveLabBaseServerDsc.ps1",
    "WEB01",
    "'$($Configuration.VirtualHardDisksPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
