param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [string]
    $ComputerName,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullorEmpty()]
    [PSCredential]
    $Credential
)

$ProgressPreference = "SilentlyContinue"

Invoke-Command -ComputerName $ComputerName -Credential $Credential -ScriptBlock {
    $ProgressPreference = "SilentlyContinue"

    Install-PackageProvider -Name "Nuget" -Force | Out-Null
    Install-Module -Name "ActiveDirectoryCSDsc" -Repository "PSGallery" -Force
    Install-Module -Name "ActiveDirectoryDsc" -Repository "PSGallery" -Force
    Install-Module -Name "ComputerManagementDsc" -Repository "PSGallery" -Force
    Install-Module -Name "NetworkingDsc" -Repository "PSGallery" -Force
    Install-Module -Name "PSDesiredStateConfiguration" -Repository "PSGallery" -Force
    Install-Module -Name "SqlServerDsc" -Repository "PSGallery" -Force
    Install-Module -Name "xHyper-V" -Repository "PSGallery" -Force
}
