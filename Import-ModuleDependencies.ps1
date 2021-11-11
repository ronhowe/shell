#requires -PSEdition Core

Get-Content -Path "$PSScriptRoot\ModuleDependencies.csv" |
ForEach-Object {
    if ($_ -eq "Az") {
        Write-Output "Importing Module Az.Accounts"
        Import-Module -Name "Az.Accounts"
    }
    else {
        Write-Output "Importing Module $_"
        Import-Module -Name $_
    }
}
