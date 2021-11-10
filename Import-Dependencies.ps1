#requires -PSEdition Core

@(
    # "Az",
    "Az.Accounts",
    "Microsoft.PowerShell.SecretManagement",
    "Microsoft.PowerShell.SecretStore",
    "oh-my-posh",
    "Pester",
    "posh-git",
    "PowerConfig",
    "WindowsCompatibility"
) |
ForEach-Object {
    Import-Module -Name $_
}
