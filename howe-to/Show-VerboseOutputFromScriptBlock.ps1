$ScriptBlock = {
    [CmdletBinding()]
    param()
    Write-Verbose "Verbose Message"
}

# Does not work.
# https://github.com/PowerShell/PowerShell/issues/4040
Invoke-Command -ScriptBlock $ScriptBlock -Verbose

$ScriptBlock = {
    param(
        [ValidateSet("Continue", "SilentlyContinue")]
        [string]
        $VerbosePreference = "SilentlyContinue"
    )
    $VerbosePreference = $VerbosePreference
    Write-Verbose "Verbose Message"
}

# Hack works.
Invoke-Command -ScriptBlock $ScriptBlock -ArgumentList "Continue"
