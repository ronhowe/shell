#requires -RunAsAdministrator
#requires -PSEdition Core

param(
    [Parameter(Mandatory = $true)]
    [string]
    $VMName,

    [Parameter(Mandatory = $true)]
    [string]
    $InvokeDscScriptPath
)

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    $InvokeDscScriptPath,
    $VMName,
    "'$($MyConfiguration.VirtualHardDisksPath)'",
    "'$($MyConfiguration.WindowsServerIsoPath)'",
    "'$($MyConfiguration.SqlServerIsoPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
