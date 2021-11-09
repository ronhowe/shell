@(
    "Az",
    "Microsoft.PowerShell.SecretManagement",
    "Microsoft.PowerShell.SecretStore",
    "oh-my-posh",
    "Pester",
    "posh-git",
    "PowerConfig",
    "WindowsCompatibility"
) |
ForEach-Object {
    Install-Module -Name $_ -Repository "PSGallery" -Force
}
