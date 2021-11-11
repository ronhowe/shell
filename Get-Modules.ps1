return Get-Content -Path "$PSScriptRoot\Modules.txt" | Where-Object { ($_.Length -gt 0) -and (-not $_.StartsWith('#')) }
