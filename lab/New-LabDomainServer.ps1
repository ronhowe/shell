#requires -RunAsAdministrator
#requires -PSEdition Core

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    "$PSScriptRoot\Invoke-NewLabDomainServerDsc.ps1",
    "DC01",
    "'$($Configuration.VirtualHardDisksPath)'",
    "'$($Configuration.WindowsServerIsoPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
