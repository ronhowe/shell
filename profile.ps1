# Create a symbolic link to the repo wherever it lives.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts (Visual Studio Code, PowerShell, etc.)
# . "~/repos/ronhowe/powershell/profile.ps1"

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
    . "~/repos/ronhowe/powershell/profile.ps1"
}

function repos {
    Clear-Host
    Set-Location -Path "~/repos/"
}
