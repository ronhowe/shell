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
    "'$($Configuration.VirtualHardDisksPath)'",
    "'$($Configuration.WindowsServerIsoPath)'",
    "'$($Configuration.SqlServerIsoPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
