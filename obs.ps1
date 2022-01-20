#region invocation

end {
    Clear-Host
    
    $Parameters = @{
        HandbrakeInputPath  = "D:\OBS\The Book of Puhg\10-handbrake"
        HandbrakeOutputPath = "D:\OBS\The Book of Puhg\20-azcopy"
        HandbrakeCliPath    = "~\Downloads\HandBrakeCLI-1.5.0-win-x86_64\HandBrakeCLI.exe"
        AzCopyPath          = "~\Downloads\azcopy_windows_amd64_10.13.0\azcopy.exe"
        ZipPath             = "C:\Program Files\7-Zip\7z.exe"
        AzureStorageAccount = "https://ronhowe.blob.core.windows.net"
        Verbose             = $true
    }

    Invoke-ObsWorkflow @Parameters
}

#endregion invocation

#region implementation

begin {
    function Invoke-ObsWorkflow {
        #region Parameters

        [CmdletBinding()]
        param (
            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            $HandbrakeInputPath,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            $HandbrakeOutputPath,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            $HandbrakeCliPath,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            $AzCopyPath,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            $ZipPath,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            $AzureStorageAccount
        )

        #endregion Parameters

        $ErrorActionPreference = "Stop"

        #region Validate Input

        if (Test-Path -Path $HandbrakeInputPath) {
            Write-Verbose "`$HandbrakeInputPath = $HandbrakeInputPath"
        }
        else {
            Write-Error "Could not find $HandbrakeInputPath."
        }

        if (Test-Path -Path $HandbrakeOutputPath) {
            Write-Verbose "`$HandbrakeOutputPath = $HandbrakeOutputPath"
        }
        else {
            Write-Error "Could not find $HandbrakeInputPath." -ErrorAction Stop
        }

        if (Test-Path -Path $HandbrakeCliPath) {
            Write-Verbose "`$HandbrakeCliPath = $HandbrakeCliPath"
        }
        else {
            Write-Error "Could not find $HandbrakeCliPath." -ErrorAction Stop
        }

        if (Test-Path -Path $AzCopyPath) {
            Write-Verbose "`$AzCopyPath = $AzCopyPath"
        }
        else {
            Write-Error "Could not find $AzCopyPath." -ErrorAction Stop
        }

        if (Test-Path -Path $ZipPath) {
            Write-Verbose "`$ZipPath = $ZipPath"
        }
        else {
            Write-Error "Could not find $ZipPath." -ErrorAction Stop
        }

        #endregion Validate Input

        #region 10-handbrake

        Get-ChildItem -Path $HandbrakeInputPath -Filter "*.mkv" |
        ForEach-Object {
            $MkvPath = $_.FullName

            Write-Verbose "`$MkvPath = $MkvPath"

            $Mp4Path = Join-Path -Path $HandbrakeOutputPath -ChildPath $($_.Name.Replace(".mkv", ".mp4"))

            Write-Verbose "`$Mp4Path = $Mp4Path"

            if (-not (Test-Path -Path $Mp4Path)) {
                Write-Verbose "Starting Handbrake"

                # https://handbrake.fr/docs/en/latest/cli/command-line-reference.html
                Start-Process -Path $HandbrakeCliPath -ArgumentList "--input", "`"$MkvPath`"", "--output", "`"$Mp4Path`"", "--all-audio" -Wait -NoNewWindow
            }

            if (Test-Path -Path $Mp4Path) {
                Write-Verbose "Deleting MKV"

                Remove-Item -Path $MkvPath
            }
            else {
                Write-Error "MP4 Missing - Handbrake Failure?" -ErrorAction Stop
            }
        }

        #endregion 10-handbrake

        #region 20-azcopy

        Get-ChildItem -Path $HandbrakeOutputPath -Filter "*.mp4" | ForEach-Object {
            $Mp4Path = $_.FullName

            Write-Verbose "`$Mp4Path = $Mp4Path"

            $BaseName = $_.BaseName

            Write-Verbose "`$BaseName = $BaseName"

            # TODO - Test Azure Copy Not Exists

            # e.g. https://ronhowe.blob.core.windows.net/star-wars-the-old-republic/Pofe%20and%20Gray%20001%20-%20BAD%20QUALITY.mp4
            $AzureStoragePath = $("{0}/raw/{1}.mp4" -f $AzureStorageAccount, $BaseName).ToLower().Replace(" ", "-")

            Write-Verbose "`$AzureStoragePath = $AzureStoragePath"

            # https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-blobs-upload?toc=/azure/storage/blobs/toc.json
            # Start-Process -Path $AzCopyPath -ArgumentList "copy", $Mp4Path, $AzureStoragePath -Wait -NoNewWindow
            Write-Warning "Step Not Implemented (20-azcopy)"
        }

        #endregion 20-azcopy

        #region 30-resolve
        #endregion 30-resolve

        #region 40-azcopy
        #endregion 40-azcopy

        #region 50-final
        #endregion 50-final

        #region 60-youtube
        #endregion 60-youtube

        #region 70-recycle
        #endregion 70-recycle
    }
}

#endregion implementation
