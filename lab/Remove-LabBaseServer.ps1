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

Get-VM -Name $VMName -ErrorAction SilentlyContinue | Stop-VM -ErrorAction SilentlyContinue

$ArgumentList = @(
    "-NoLogo",
    "-NoProfile",
    $InvokeDscScriptPath,
    $VMName,
    "'$($Configuration.VirtualHardDisksPath)'"
)

Start-Process -FilePath "powershell.exe" -ArgumentList $ArgumentList -NoNewWindow -Wait
