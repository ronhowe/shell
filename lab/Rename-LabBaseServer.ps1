#requires -RunAsAdministrator
#requires -PSEdition Core
#requires -Modules "Hyper-V"

param(
    [Parameter(Mandatory = $true)]
    [string]
    $VMName
)

Invoke-Command -VMName $VMName -Credential $MyConfiguration.VmAdministratorCredential -ScriptBlock { Rename-Computer -NewName $using:VMName }

Restart-VM -Name $VMName -Wait -Force
