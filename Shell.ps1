#requires -PSEdition Core
# All versions as of 2022-06-28.
#requires -Modules @{ ModuleName = "Az.Accounts"; ModuleVersion = "2.8.0" }
#requires -Modules @{ ModuleName = "Az.Tools.Predictor"; ModuleVersion = "1.0.1" }
#requires -Modules @{ ModuleName = "posh-git"; ModuleVersion = "1.0.1" }

# Create a symbolic link to your repos root folder.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts. (Visual Studio Code, PowerShell, etc.)
# . "~\repos\ronhowe\shell\Shell.ps1"

$ProgressPreference = "SilentlyContinue"

Set-PSReadLineOption -PredictionViewStyle ListView

# . "$PSScriptRoot\Import-MyModules.ps1"
# . "$PSScriptRoot\Import-MyConfigurations.ps1"
# . "$PSScriptRoot\Import-MySecrets.ps1"

# if (Test-Path -Path "$PSScriptRoot\ronhowe.omp.json" -ErrorAction SilentlyContinue) {
#     Set-PoshPrompt -Theme "$PSScriptRoot\ronhowe.omp.json"
# }

function default {
    function global:prompt {
        "PS $($executionContext.SessionState.Path.CurrentLocation)$('>' * ($nestedPromptLevel + 1)) ";
    }
}

function edit {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateNotNullorEmpty()]
        $Path
    )
    Start-Process -Path "C:\Program Files\Notepad++\notepad++.exe" -ArgumentList "`"$Path`""
}

function home {
    Set-Location -Path "~"
}

function junk {
    Set-Location -Path "~\junk"
}

function kernel {
    Set-Location -Path "~\repos\ronhowe\kernel"
}

function lab {
    Set-Location -Path "~\repos\ronhowe\lab"
}

function log {
    # e.g. ~\junk\637940767727486236.log
    $TranscriptPath = Join-Path -Path "~\junk" -ChildPath "$($(Get-Date).Ticks).log"
    Start-Transcript -Path $TranscriptPath
}

function quiet {
    function global:prompt { " `b"; }
}

function repos {
    Set-Location -Path "~\repos"
}

function ronhowe {
    Write-Host "r" -BackgroundColor Red -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkYellow -ForegroundColor Black -NoNewline
    Write-Host "n" -BackgroundColor Yellow -ForegroundColor Black -NoNewline
    Write-Host "h" -BackgroundColor Green -ForegroundColor Black -NoNewline
    Write-Host "o" -BackgroundColor DarkBlue -ForegroundColor Black -NoNewline
    Write-Host "w" -BackgroundColor Blue -ForegroundColor Black -NoNewline
    Write-Host "e" -BackgroundColor Cyan -ForegroundColor Black -NoNewline
}

function shell {
    Set-Location -Path "~\repos\ronhowe\shell"
}

function Test-Administrator {
    $identity = New-Object -TypeName "Security.Principal.WindowsPrincipal" -ArgumentList $([Security.Principal.WindowsIdentity]::GetCurrent())
    $identity.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

home
Clear-Host
Write-Host "READY" -ForegroundColor Green
