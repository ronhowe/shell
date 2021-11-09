#requires -RunAsAdministrator
#requires -PSEdition Core

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    "$PSScriptRoot\Invoke-NewLabWebServerDsc.ps1",
    "WEB01",
    "'$($Configuration.VirtualHardDisksPath)'",
    "'$($Configuration.WindowsServerIsoPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
