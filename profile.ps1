# Create a symbolic link to the repo wherever it lives.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts (Visual Studio Code, PowerShell, etc.)
# . "~/repos/ronhowe/powershell/profile.ps1"

Write-Host "Loading personal profile..."

function Write-RonHowe {
    Write-Host "r" -BackgroundColor Red -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkYellow -ForegroundColor Black -NoNewline
    Write-Host "n" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
    Write-Host "h" -BackgroundColor Green -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkBlue -ForegroundColor Black -NoNewline
    Write-Host "w" -BackgroundColor Blue -ForegroundColor Black -NoNewline
    Write-Host "e" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
    Write-Host " " -NoNewline
    Write-Host "$(Get-Date)" -BackgroundColor Magenta -ForegroundColor White
}

function about {
    Clear-Host
    az --version
    gh --version
    git --version
    pwsh --version
}

function brb {
    Clear-Host

    Write-RonHowe

    $StopWatch = [System.Diagnostics.Stopwatch]::New()

    $Stopwatch.Start()

    Write-Host "Apologies.  I am going AFK."

    while ($true) {
        Write-Host "I have been AFK for $($StopWatch.Elapsed.Minutes) minute(s)..."
        Start-Sleep -Seconds 60 ;
    }
}

function home {
    Clear-Host
    Set-Location -Path "~"
}

function new {
    Clear-Host
    Write-RonHowe
}

# function prompt {
#     "> "
# }

function repos {
    Clear-Host
    Set-Location -Path "~/repos/"
}

function intro {
    Clear-Host
    Start-Sleep -Seconds 3
    Write-RonHowe
    Start-Sleep -Seconds 3
    Start-Transcript
    Start-Sleep -Seconds 3
    Write-Host "Hi.  I'm Ron."
    Start-Sleep -Seconds 3
    Write-Host "I like computers."
    Start-Sleep -Seconds 3
    Write-Host "I like Dungeons & Dragons."
    Start-Sleep -Seconds 3
    Write-Host "I like Star Wars."
    Start-Sleep -Seconds 3
    Write-Host "Let's see what fun we can have."
    Start-Sleep -Seconds 3
}

function outro {

    Clear-Host
    Start-Sleep -Seconds 3
    Write-RonHowe
    Start-Sleep -Seconds 3
    Write-Host "Sorry.  That's all for now."
    Start-Sleep -Seconds 3
    Write-Host "Thanks for watching!"
    Start-Sleep -Seconds 3
    Write-Host "See you soon and..."
    Start-Sleep -Seconds 3
    Write-Host "May the Force be with you!"
    Start-Sleep -Seconds 3
    Stop-Transcript
    Start-Sleep -Seconds 3
    Clear-Host
}

Import-Module -Name "posh-git"

Set-Location -Path "~"

Write-RonHowe

Write-Host "Hi, $($env:USERNAME).  The system is ready." -ForegroundColor Green

Write-Host "Would you like to play a game?" -ForegroundColor Green
