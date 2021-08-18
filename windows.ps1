throw "Safety Net"

$Credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -AsJob -ScriptBlock {
        Rename-Computer -NewName $using:_ -Restart -Force
    }
}
