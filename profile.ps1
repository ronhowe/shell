# Create a symbolic link to your repos wherever they live.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts. (Visual Studio Code, PowerShell, etc.)
# . "~\repos\ronhowe\powershell\profile.ps1"

$ProgressPreference = "SilentlyContinue"

. "$PSScriptRoot\Import-ModuleDependencies.ps1"
. "$PSScriptRoot\Import-Configuration.ps1"
. "$PSScriptRoot\Import-Secrets.ps1"

Set-PoshPrompt -Theme "$PSScriptRoot\ronhowe.omp.json"

if (Test-Path -Path "~\repos\ronhowe\powershell" -ErrorAction SilentlyContinue) {
    Set-Location -Path "~\repos\ronhowe\powershell"
}
else {
    Set-Location -Path "~"
}

Clear-Host

function about {
    Clear-Host

    Write-Host ".NET" -ForegroundColor Black -BackgroundColor White
    dotnet --version | Select-Object -First 1

    Write-Host "Az CLI" -ForegroundColor Black -BackgroundColor White
    az --version | Select-Object -First 1

    Write-Host "Az Module" -ForegroundColor Black -BackgroundColor White
    $InstalledAzModule = Get-Module -Name "Az" -ListAvailable | Sort-Object -Property Version -Descending | Select-Object -First 1
    $InstalledAzModule.Version.ToString()
    $LatestAzModule = Find-Module -Name "Az"
    if ($InstalledAzModule.Version -ne $LatestAzModule.Version) { Write-Host "Az module upgrade is available." -ForegroundColor Red }

    Write-Host "GitHub CLI" -ForegroundColor Black -BackgroundColor White
    gh --version | Select-Object -First 1

    Write-Host "Git CLI" -ForegroundColor Black -BackgroundColor White
    git --version | Select-Object -First 1

    Write-Host "PowerShell" -ForegroundColor Black -BackgroundColor White
    pwsh --version | Select-Object -First 1

    Write-Host "Visual Studio Code" -ForegroundColor Black -BackgroundColor White
    code --version | Select-Object -First 1
}

function home {
    Clear-Host
    Set-Location -Path "~"
}

function junk {
    Clear-Host
    Push-Location -Path "$env:TEMP\junk"
}

function repos {
    Clear-Host
    Push-Location -Path "~\repos"
}

function ronhowe {
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
