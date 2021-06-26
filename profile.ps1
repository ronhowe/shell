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
    az --version
    gh --version
    git --version
    pwsh --version
}

function home {
    Clear-Host
    Set-Location -Path "~"
}

function profile {
    Clear-Host
    . "~/repos/ronhowe/powershell/profile.ps1"
}

# function prompt {

#     Write-Host "R" -BackgroundColor Red -ForegroundColor Black -NoNewline
#     Write-Host "O" -BackgroundColor DarkYellow -ForegroundColor Black -NoNewline
#     Write-Host "N" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
#     Write-Host "H" -BackgroundColor Green -ForegroundColor Black -NoNewline
#     Write-Host "O" -BackgroundColor DarkBlue -ForegroundColor Black -NoNewline
#     Write-Host "W" -BackgroundColor Blue -ForegroundColor Black -NoNewline
#     Write-Host "E" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
#     Write-Host "$(Get-Date)" -BackgroundColor Magenta -ForegroundColor White
#     "> "
# }

function prompt {
    "> "
}

function repos {
    Clear-Host
    Set-Location -Path "~/repos/"
}
