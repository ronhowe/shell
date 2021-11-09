#requires -RunAsAdministrator
#requires -PSEdition Core

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    "$PSScriptRoot\Invoke-NewLabSqlServerDsc.ps1",
    "SQL01",
    "'$($Configuration.VirtualHardDisksPath)'",
    "'$($Configuration.WindowsServerIsoPath)'",
    "'$($Configuration.SqlServerIsoPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
