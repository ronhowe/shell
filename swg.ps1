$Puhg = "255459369187" # Bounty Hunter
$Puhf = "365727770906" # Medic
$Tuhf = "365761383669" # Entertainer
$Ruhg = "366586505184" # Officer

$SwgProfilePath = "D:\StarWarsGalaxies\profiles\pug\Omega"

function Copy-PuhgProfile {
    Get-ChildItem -Path $SwgProfilePath -Filter "$Puhg.*" |
    ForEach-Object {
        Copy-Item -Path $_.FullName -Destination $_.FullName.Replace($Puhg, $Puhf) -Verbose
        Copy-Item -Path $_.FullName -Destination $_.FullName.Replace($Puhg, $Tuhf) -Verbose
        Copy-Item -Path $_.FullName -Destination $_.FullName.Replace($Puhg, $Ruhg) -Verbose
    }
}

Copy-PuhgProfile
