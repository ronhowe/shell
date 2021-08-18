throw "Safety Net"

$Credential = Get-Credential -Message "Enter Administrator Credential" -UserName "Administrator"

@("DC01", "SQL01", "WEB01") |
ForEach-Object {
    Invoke-Command -VMName $_ -Credential $Credential -AsJob -ScriptBlock {
        Install-PackageProvider -Name "NuGet" -MinimumVersion "2.8.5.201" -Force
        Install-Module -Name "PSWindowsUpdate" -Force
        Get-WindowsUpdate
        Install-WindowsUpdate -AutoReboot -Confirm:$false
    }
}
