#region invocation

end {
    $Parameters = @{
        HandbrakeInputPath  = "D:\OBS\debug"
        HandbrakeOutputPath = "D:\OBS\debug"
        HandbrakeCliPath    = "~\repos\ronhowe\shell\bin\HandBrakeCLI-1.5.1-win-x86_64\HandBrakeCLI.exe"
        AzCopyPath          = "~\repos\ronhowe\shell\bin\azcopy_windows_amd64_10.15.0\azcopy.exe"
        ZipClientPath       = "C:\Program Files\7-Zip\7z.exe"
        AzureStorageAccount = "https://ronhowe.blob.core.windows.net"
        Verbose             = $true
    }

    Invoke-ObsWorkflow @Parameters
}

#endregion invocation

#region implementation

begin {
    function Invoke-ObsWorkflow {
        #region Input Parameters

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
            $ZipClientPath,

            [Parameter(Mandatory = $true)]
            [ValidateNotNullorEmpty()]
            $AzureStorageAccount
        )

        #endregion Input Parameters

        #region Configure Runtime Environment

        $ErrorActionPreference = "Stop"

        #endregion Configure Runtime Environment

        #region Validate Parameters

        Write-Verbose "`$HandbrakeInputPath = $HandbrakeInputPath"
        if (Test-Path -Path $HandbrakeInputPath) {
            Write-Verbose "Found $HandbrakeInputPath"
        }
        else {
            Write-Error "Could not find $HandbrakeInputPath."
        }

        Write-Verbose "`$HandbrakeOutputPath = $HandbrakeOutputPath"
        if (Test-Path -Path $HandbrakeOutputPath) {
            Write-Verbose "Found $HandbrakeOutputPath"
        }
        else {
            Write-Error "Could not find $HandbrakeInputPath." -ErrorAction Stop
        }

        Write-Verbose "`$HandbrakeCliPath = $HandbrakeCliPath"
        if (Test-Path -Path $HandbrakeCliPath) {
            Write-Verbose "Found $HandbrakeCliPath"
        }
        else {
            Write-Error "Could not find $HandbrakeCliPath." -ErrorAction Stop
        }

        Write-Debug "Section Not Implemented"
        if ($false) {
            Write-Verbose "`$AzCopyPath = $AzCopyPath"
            if (Test-Path -Path $AzCopyPath) {
                Write-Verbose "Found $AzCopyPath"
            }
            else {
                Write-Error "Could not find $AzCopyPath." -ErrorAction Stop
            }

            Write-Verbose "`$ZipClientPath = $ZipClientPath"
            if (Test-Path -Path $ZipClientPath) {
                Write-Verbose "Found $ZipClientPath"
            }
            else {
                Write-Error "Could not find $ZipClientPath." -ErrorAction Stop
            }
        }

        #endregion Validate Parameters

        #region Transcode with Handbrake CLI

        Write-Verbose "Begin Transcode with Handbrake CLI"

        Get-ChildItem -Path $HandbrakeInputPath -Filter "*.mkv" |
        ForEach-Object {
            $MkvPath = $_.FullName

            Write-Verbose "`$MkvPath = $MkvPath"

            $Mp4Path = Join-Path -Path $HandbrakeOutputPath -ChildPath $($_.Name.Replace(".mkv", ".mp4"))

            Write-Verbose "`$Mp4Path = $Mp4Path"

            if (-not (Test-Path -Path $Mp4Path)) {
                Write-Verbose "Starting Handbrake CLI"

                # https://handbrake.fr/docs/en/latest/cli/command-line-reference.html
                Start-Process -Path $HandbrakeCliPath -ArgumentList "--input", "`"$MkvPath`"", "--output", "`"$Mp4Path`"", "--all-audio" -Wait -NoNewWindow
            }

            # TODO - Handle Process Return Code

            if (Test-Path -Path $Mp4Path) {
                Write-Verbose "Confirmed $Mp4Path"
            }
            else {
                Write-Error "Could not find $Mp4Path"
                Write-Error "MP4 Missing After Call To Handbrake CLI" -ErrorAction Stop
            }

            Write-Verbose "End Transcode with Handbrake CLI"
        }

        #endregion Transcode with Handbrake CLI

        Write-Debug "Section Not Implemented"
        if ($false) {
            #region Upload to Azure Storage

            Write-Verbose "Begin Upload to Azure Storage"

            Get-ChildItem -Path $HandbrakeOutputPath -Filter "*.mp4" | ForEach-Object {

                $Mp4Path = $_.FullName

                Write-Verbose "`$Mp4Path = $Mp4Path"

                $BaseName = $_.BaseName

                Write-Verbose "`$BaseName = $BaseName"

                # TODO - Test Azure Copy Not Exists

                # e.g. https://ronhowe.blob.core.windows.net/star-wars-the-old-republic/Pofe%20and%20Gray%20001%20-%20BAD%20QUALITY.mp4
                $AzureStoragePath = $("{0}/raw/{1}.mp4" -f $AzureStorageAccount, $BaseName).ToLower().Replace(" ", "-")

                Write-Verbose "`$AzureStoragePath = $AzureStoragePath"

                Write-Verbose "Starting AzCopy"

                # https://docs.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-blobs-upload?toc=/azure/storage/blobs/toc.json
                Start-Process -Path $AzCopyPath -ArgumentList "copy", $Mp4Path, $AzureStoragePath -Wait -NoNewWindow

                # TODO - Handle Process Return Code
                # TODO - Verify Azure Storage Blob
                # TODO - Set Azure Storage Blob to Cold/Archive?

                Write-Verbose "End Upload to Azure Storage"
            }

            #endregion Upload to Azure Storage
        }

        Write-Verbose "OBS Workflow Complete"
    }
}

#endregion implementation
