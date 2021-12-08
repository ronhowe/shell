# @TODO @RevisitPSEditionRequirements
# requires -PSEdition Core

$ProgressPreference = "SilentlyContinue"

& "$PSScriptRoot\Get-MyModules.ps1" |
ForEach-Object {
    Write-Output "Installing Module $_"
    Install-Module -Name $_ -Scope CurrentUser -Repository "PSGallery" -Force -Verbose
}
