# https://dba.stackexchange.com/questions/295714/changing-ssms-settings-via-powershell

# SSMS 16
if (Test-Path -Path 'C:\Program Files (x86)\Microsoft SQL Server\130\Tools\Binn\ManagementStudio\ssms.pkgundef') {
    powershell -NoLogo -NoProfile -Command "(Get-Content -Path 'C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\ssms.pkgundef') -replace '\[\`$RootKey\`$\\Themes\\{1ded0138-47ce-435e-84ef-9ec1f439b749}\]', '//[`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]' | Out-File -FilePath 'C:\Program Files (x86)\Microsoft SQL Server\130\Tools\Binn\ManagementStudio\ssms.pkgundef'" -NoProfile
}
# SSMS 17
elseif (Test-Path -Path 'C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\ssms.pkgundef') {
    powershell -NoLogo -NoProfile -Command "(Get-Content -Path 'C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\ssms.pkgundef') -replace '\[\`$RootKey\`$\\Themes\\{1ded0138-47ce-435e-84ef-9ec1f439b749}\]', '//[`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]' | Out-File -FilePath 'C:\Program Files (x86)\Microsoft SQL Server\140\Tools\Binn\ManagementStudio\ssms.pkgundef'" -NoProfile
}
# SSMS 18
elseif (Test-Path -Path 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\ssms.pkgundef') {
    powershell -NoLogo -NoProfile -Command "(Get-Content -Path 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\ssms.pkgundef') -replace '\[\`$RootKey\`$\\Themes\\{1ded0138-47ce-435e-84ef-9ec1f439b749}\]', '//[`$RootKey`$\Themes\{1ded0138-47ce-435e-84ef-9ec1f439b749}]' | Out-File -FilePath 'C:\Program Files (x86)\Microsoft SQL Server Management Studio 18\Common7\IDE\ssms.pkgundef'"
}
else {
    Write-Output 'ssms.pkgundef not found'
}
