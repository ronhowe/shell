param (
    [ValidateSet("N", "S", "W")]
    [string]
    $ObsSource = "S",

    $ObsPath = "D:/OBS",

    $RenderPath = "D:/Render",

    $HandbrakePath = "~/Downloads/HandBrakeCLI-1.3.3-win-x86_64/HandBrakeCLI.exe",

    $AzCopyPath = "~/Downloads/azcopy_windows_amd64_10.10.0/azcopy.exe",

    $AzureStorageAccount = "https://ronhowe.blob.core.windows.net"
)

Clear-Host

$ErrorActionPreference = "Stop"

if (Test-Path -Path $ObsPath) {
    Write-Host "`$ObsPath = $ObsPath"
}
else {
    Write-Error "Could not find $ObsPath."
}

if (Test-Path -Path $HandbrakePath) {
    Write-Host "`$HandbrakePath = $HandbrakePath"
}
else {
    Write-Error "Could not find $HandbrakePath."
}

if (Test-Path -Path $AzCopyPath) {
    Write-Host "`$AzCopyPath = $AzCopyPath"
}
else {
    Write-Error "Could not find $AzCopyPath." -ErrorAction Stop
}

# $ObsSources = @{
#     "N" = "Neverwinter";
#     "S" = "Star Wars The Old Republic";
#     "W" = "World of Warcraft";
# }

# $ObsSources.Values | ForEach-Object {
#     $ObsSourcePath = Join-Path -Path $ObsPath -ChildPath $_

#     Write-Host "`$ObsSourcePath = $ObsSourcePath"

#     if (-not (Test-Path -Path $ObsSourcePath)) {
#         New-Item -ItemType Directory -Path $ObsSourcePath
#     }
# }

#region Process MK4
Get-ChildItem -Path $ObsPath -Include "*.mkv" -Recurse | ForEach-Object {
    $MkvPath = $_.FullName

    Write-Host "`$MkvPath = $MkvPath"

    $Mp4Path = $MkvPath.Replace(".mkv", ".mp4")

    Write-Host "`$Mp4Path = $Mp4Path"

    if (-not (Test-Path -Path $Mp4Path)) {
        # https://handbrake.fr/docs/en/latest/cli/command-line-reference.html
        Start-Process -Path $HandbrakePath -ArgumentList "--input", $MkvPath, "--output", $Mp4Path, "--all-audio" -Wait -NoNewWindow
    }

    Remove-Item -Path $MkvPath
}
#endregion Process MK4

#region Process MP4
Get-ChildItem -Path $RenderPath -Include "*.mp4" -Recurse | ForEach-Object {
    $Mp4Path = $_.FullName

    Write-Host "`$Mp4Path = $Mp4Path"

    $BaseName = $_.BaseName

    Write-Host "`$BaseName = $BaseName"

    # TODO - Test Azure Copy Not Exists

    # e.g. https://ronhowe.blob.core.windows.net/star-wars-the-old-republic/Pofe%20and%20Gray%20001%20-%20BAD%20QUALITY.mp4
    $AzureStoragePath = $("{0}/render/{1}.mp4" -f $AzureStorageAccount, $BaseName).ToLower().Replace(" ", "-")

    Write-Host "`$AzureStoragePath = $AzureStoragePath"

    # https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-blobs-upload?toc=/azure/storage/blobs/toc.json
    # Start-Process -Path $AzCopyPath -ArgumentList "copy", $Mp4Path, $AzureStoragePath -Wait -NoNewWindow
    Write-Warning "AzCopy Not Implemented"
}
#endregion Process MP4
