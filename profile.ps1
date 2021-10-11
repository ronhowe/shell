# Create a symbolic link to your repos wherever they live.
# Set-Location -Path "~"
# New-Item -ItemType SymbolicLink -Path "repos" -Target "D:\repos"

# Add links to this profile from any/all PowerShell hosts (Visual Studio Code, PowerShell, etc.)
# . "~/repos/ronhowe/powershell/profile.ps1"

end {
    Write-Debug "Loading personal profile..."
    if (Get-Module -Name "posh-git" -ListAvailable) {
        Import-Module -Name "posh-git"
    }
    Set-Location -Path "~"
    Clear-Host
    Write-RonHowe
    Write-Host "Would you like to play a game?" -ForegroundColor Green
}
begin {
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
        az --version | Select-String -Pattern "azure-cli"
        gh --version
        git --version
        pwsh --version
        code --version
        $CurrentModule = Find-Module -Name 'Az'
        $InstalledVersion = Get-Module -Name 'Az' -ListAvailable | Sort-Object -Property Version -Descending | Select-Object -First 1
        if ($CurrentModule.Version -ne $InstalledVersion.Version) { Write-Host "Az module upgrade is available." -ForegroundColor Red }
        Write-Host "Current Az Module" $CurrentModule.Version.ToString()
        Write-Host "Installed Az Module" $InstalledVersion.Version.ToString()
    }

    function afk {
        Clear-Host
        Write-RonHowe
        $StopWatch = [System.Diagnostics.Stopwatch]::New()
        $Stopwatch.Start()
        Write-Host "Sorry.  I'll be right back."
        while ($true) {
            Write-Host "I have been AFK for $($StopWatch.Elapsed.Minutes) minute(s)..."
            Start-Sleep -Seconds 60 ;
        }
    }

    function home {
        Clear-Host
        Set-Location -Path "~"
    }

    function intro {
        [int] $delay = 1
        Clear-Host
        Write-RonHowe
        Start-Sleep -Seconds $delay
        Write-Host "Name: " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "Ron Howe"
        Start-Sleep -Seconds $delay
        Write-Host "E-mail: " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "ronhowe@hotmail.com"
        Start-Sleep -Seconds $delay
        Write-Host "GitHub" -BackgroundColor Gray -ForegroundColor Black -NoNewline
        Write-Host ": " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "github.com/ronhowe"
        Start-Sleep -Seconds $delay
    }

    function outro {
        [int] $delay = 1
        Clear-Host
        Start-Sleep -Seconds $delay
        Write-RonHowe
        Start-Sleep -Seconds $delay
        Write-Host "That's all for now."
        Start-Sleep -Seconds $delay
        Write-Host "Thanks for watching."
        Start-Sleep -Seconds $delay
        Write-Host "E-mail: " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "ronhowe@hotmail.com"
        Start-Sleep -Seconds $delay
        Write-Host "GitHub" -BackgroundColor Gray -ForegroundColor Black -NoNewline
        Write-Host ": " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "github.com/ronhowe"
        Start-Sleep -Seconds $delay
        Write-Host "Twitch" -BackgroundColor DarkMagenta -ForegroundColor Black -NoNewline
        Write-Host ": " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "twitch.tv/puhg"
        Start-Sleep -Seconds $delay
        Write-Host "Twitter" -BackgroundColor Cyan -ForegroundColor White -NoNewline
        Write-Host ": " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "twitter.com/ronhowe"
        Start-Sleep -Seconds $delay
        Write-Host "YouTube" -BackgroundColor Red -ForegroundColor White -NoNewline
        Write-Host ": " -NoNewline
        Start-Sleep -Seconds $delay
        Write-Host "youtube.com/user/ronhowex"
        Start-Sleep -Seconds $delay
        Write-Host "May the Force be with you".ToUpper() -ForegroundColor Yellow
        Start-Sleep -Seconds $delay
    }

    function junk {
        Clear-Host
        Push-Location -Path "$env:TEMP/junk"
    }

    function new {
        Clear-Host
        Write-RonHowe
    }

    function prompt {
        return "> "
    }

    function reload {
        . "~/repos/ronhowe/powershell/profile.ps1"
    }
    
    function repos {
        Clear-Host
        Push-Location -Path "~/repos/"
    }
}
