#requires -PSEdition Core

$ProgressPreference = "SilentlyContinue"

Get-Content -Path "$PSScriptRoot\ModuleDependencies.csv" |
ForEach-Object {
    Write-Output "Installing Module $_"
    Install-Module -Name $_ -Scope CurrentUser -Repository "PSGallery" -Force
}
