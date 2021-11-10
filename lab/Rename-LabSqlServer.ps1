Invoke-Command -VMName "SQL01" -Credential $AdministratorCredential -ScriptBlock { Rename-Computer -NewName "SQL01" ; Restart-Computer -Force }
