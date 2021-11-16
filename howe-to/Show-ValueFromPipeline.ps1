function Howe-To {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [string[]]
        $Items
    )
    begin {
        Write-Host "begin" -ForegroundColor Green
    }
    process {
        Write-Host "process+" -ForegroundColor Yellow
        foreach ($Item in $Items) {
            Write-Host $Item
        }
        Write-Host "process-" -ForegroundColor Yellow
    }
    end {
        Write-Host "end" -ForegroundColor Red
    }
}

Clear-Host
Howe-To -Items 1
Write-Host ""
Howe-To -Items @(1, 2)
Write-Host ""
@(1..2) | Howe-To
Write-Host ""
