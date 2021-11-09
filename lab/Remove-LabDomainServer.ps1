#requires -RunAsAdministrator
#requires -PSEdition Core

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    "$PSScriptRoot\Invoke-RemoveLabBaseServerDsc.ps1",
    "DC01",
    "'$($Configuration.VirtualHardDisksPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
