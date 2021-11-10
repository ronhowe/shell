Invoke-Command -VMName "WEB01" -Credential $AdministratorCredential -ScriptBlock { Rename-Computer -NewName "WEB01" ; Restart-Computer -Force }
