Invoke-Command -VMName "DC01" -Credential $AdministratorCredential -ScriptBlock { Rename-Computer -NewName "DC01" ; Restart-Computer -Force }
