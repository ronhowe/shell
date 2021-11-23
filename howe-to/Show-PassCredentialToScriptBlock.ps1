$ScriptBlock1 = {
    param(
        [ValidateNotNullorEmpty()]
        [string]
        $UserName,

        [ValidateNotNullorEmpty()]
        [securestring]
        $Password
    )
    Write-Host $UserName -ForegroundColor Green
    Write-Host $Password -ForegroundColor Green
}

$ScriptBlock2 = {
    param(
        [ValidateNotNullorEmpty()]
        [PSCredential]
        $Credential
    )
    Write-Host $Credential.UserName -ForegroundColor Blue
    Write-Host $Credential.Password -ForegroundColor Blue
}

Clear-Host
$Credential = Get-Credential
Invoke-Command -VMName "DC01" -Credential $Credential -ScriptBlock $ScriptBlock1 -ArgumentList @($Credential.UserName, $Credential.Password)
Invoke-Command -VMName "DC01" -Credential $Credential -ScriptBlock $ScriptBlock2 -ArgumentList $Credential
