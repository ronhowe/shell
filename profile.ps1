#requires -PSEdition Core
# All versions as of 2022-06-28.
#requires -Modules @{ ModuleName = "Az.Accounts"; ModuleVersion = "2.8.0" }
#requires -Modules @{ ModuleName = "Az.Tools.Predictor"; ModuleVersion = "1.0.1" }
#requires -Modules @{ ModuleName = "posh-git"; ModuleVersion = "1.0.1" }

# Create a symbolic link to your repos root folder.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts. (Visual Studio Code, PowerShell, etc.)
# . "~\repos\ronhowe\shell\profile.ps1"

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

function home {
    Set-Location -Path "~"
    Clear-Host
}

function junk {
    Set-Location -Path "$env:TEMP\junk"
    Clear-Host
}

function lab {
    Set-Location -Path "~\repos\ronhowe\lab"
    Clear-Host
}

function kernel {
    Set-Location -Path "~\repos\ronhowe\kernel"
    Clear-Host
}

function quiet {
    function global:prompt { " `b"; }
}

function repos {
    Set-Location -Path "~\repos"
    Clear-Host
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
    Clear-Host
}

function Test-Administrator {
    $identity = New-Object -TypeName "Security.Principal.WindowsPrincipal" -ArgumentList $([Security.Principal.WindowsIdentity]::GetCurrent())
    $identity.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

Set-Location -Path "~"
Clear-Host
Write-Host "READY" -ForegroundColor Green
