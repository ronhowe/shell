#requires -PSEdition Core

& "$PSScriptRoot\Get-Modules.ps1" |
ForEach-Object {
    if ($_ -eq "Az") {
        Write-Output "Importing Module Az.Accounts"
        Import-Module -Name "Az.Accounts"
        return
    }
    Write-Output "Importing Module $_"
    Import-Module -Name $_
}
