# Create a symbolic link to the repo wherever it lives.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts (Visual Studio Code, PowerShell, etc.)
# . "~/repos/ronhowe/powershell/profile.ps1"

# Write-Host "Loading personal profile..."

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
    $CurrentModule = Find-Module -Name 'Az'
    $InstalledVersion = Get-Module -Name 'Az' -ListAvailable | Sort-Object -Property Version -Descending | Select-Object -First 1
    if ($CurrentModule.Version -ne $InstalledVersion.Version) { Write-Host "Az module upgrade is available." -ForegroundColor Red }
    Write-Host "Current Az Module" $CurrentModule.Version.ToString()
    Write-Host "Installed Az Module" $InstalledVersion.Version.ToString()
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

function prompt {
    return "> "
}

function repos {
    Clear-Host
    Push-Location -Path "~/repos/"
}

function junk {
    Clear-Host
    Push-Location -Path "$env:TEMP/junk"
}

function intro {
    function global:prompt { Write-Host ">" -NoNewline -ForegroundColor Red; return " " }
    Clear-Host
    Start-Sleep -Seconds 1
    Start-Transcript | Out-Null
    Write-RonHowe
    Start-Sleep -Seconds 1
    Write-Host "Hello."
    Start-Sleep -Seconds 1
    Write-Host "My name is Ron Howe."
    Start-Sleep -Seconds 1
    Write-Host "My e-mail is ronhowe@hotmail.com."
    Start-Sleep -Seconds 1
    Write-Host "I like computers."
    Start-Sleep -Seconds 1
    Write-Host "I like Dungeons & Dragons."
    Start-Sleep -Seconds 1
    Write-Host "I like Star Wars."
    Start-Sleep -Seconds 1
}

function outro {
    Clear-Host
    Start-Sleep -Seconds 1
    Write-RonHowe
    Start-Sleep -Seconds 1
    Write-Host "That's all for now."
    Start-Sleep -Seconds 1
    Write-Host "Thanks for watching."
    Start-Sleep -Seconds 1
    Write-Host "May the Force be with you."
    Start-Sleep -Seconds 1
    try { Stop-Transcript | Out-Null } catch { }
    Start-Sleep -Seconds 1
    function global:prompt { Write-Host ">" -NoNewline; return " " }
}

if (Get-Module -Name "posh-git" -ListAvailable) {
    Import-Module -Name "posh-git"
}

Set-Location -Path "~"

Write-RonHowe

# Write-Host "Hi, $($env:USERNAME).  The system is ready." -ForegroundColor Green

# Write-Host "Would you like to play a game?" -ForegroundColor Green
