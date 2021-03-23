Write-Host "Importing profile..." -ForegroundColor Green

Import-Module -Name "posh-git"

Set-Location -Path "~"

function about {
    Clear-Host
    git --version
    gh --version
    az --version
}

function home {
    Clear-Host
    Set-Location -Path "~"
}

function profile {
    Clear-Host
    . "~/source/repos/ronhowe/powershell/profile.ps1"
}
function repos {
    Clear-Host
    Set-Location -Path "~/source/repos/"
}
