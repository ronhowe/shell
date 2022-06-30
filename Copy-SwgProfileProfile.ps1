[CmdletBinding()]
param (
    [ValidateNotNullorEmpty()]
    [string]
    $ProfilePath = "D:\StarWarsGalaxies\profiles\pug\Omega",

    [ValidateNotNullorEmpty()]
    [string]
    $ProfileId = "710162609564", # Puhg

    [ValidateNotNullorEmpty()]
    [string[]]
    $TargetProfileId = @("000000000000", "111111111111")
)

Get-ChildItem -Path $ProfilePath -Filter "$ProfileId.*" |
ForEach-Object {
    foreach ($targetId in $TargetProfileId) {
        Copy-Item -Path $_.FullName -Destination $_.FullName.Replace($ProfileId, $targetId)
    }
}
