# Create a symbolic link to your repos root folder.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts. (Visual Studio Code, PowerShell, etc.)
# . "~\repos\ronhowe\shell\profile.ps1"

$ProgressPreference = "SilentlyContinue"

# https://www.hanselman.com/blog/adding-predictive-intellisense-to-my-windows-terminal-powershell-prompt-with-psreadline
# https://devblogs.microsoft.com/powershell/announcing-psreadline-2-1-with-predictive-intellisense/?WT.mc_id=-blog-scottha
# https://www.learningkoala.com/powershell-psreadline-21-and-higher.html#mcetoc_1f2uetbp63ei
if ($PSVersionTable.PSEdition -eq "Core") {
    Import-Module -Name "Az.Tools.Predictor"
    Set-PSReadLineOption -PredictionSource HistoryAndPlugin
    Set-PSReadLineOption -PredictionViewStyle ListView
}

. "$PSScriptRoot\Import-MyModules.ps1"
# . "$PSScriptRoot\Import-MyConfigurations.ps1"
# . "$PSScriptRoot\Import-MySecrets.ps1"

# if (Test-Path -Path "$PSScriptRoot\ronhowe.omp.json" -ErrorAction SilentlyContinue) {
#     Set-PoshPrompt -Theme "$PSScriptRoot\ronhowe.omp.json"
# }

$DefaultPath = "~\repos\ronhowe\shell"

if (Test-Path -Path $DefaultPath -ErrorAction SilentlyContinue) {
    Set-Location -Path $DefaultPath
}
else {
    Set-Location -Path "~"
}

# TODO Custom Code Per Host
# e.g. For the Developer PowerShell Host in Visual Studio:
# $DefaultPath = "~\repos\ronhowe\kernel"
# Connect-AzAccount -TenantId e70383c6-f597-488d-9796-9c2cb3788d7c

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

function lab {
    Clear-Host
    Push-Location -Path "~\repos\ronhowe\lab"
}

function kernel {
    Clear-Host
    Push-Location -Path "~\repos\ronhowe\kernel"
}

# function prompt {
#     "> "
# }

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

function shell {
    Clear-Host
    Push-Location -Path "~\repos\ronhowe\shell"
}

function Test-Administrator {
    $identity = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
    $identity.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}
