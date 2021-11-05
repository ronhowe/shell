#############################################################################################################################################################################
#region Az Module

Find-Module -Name "Az" -Repository "PSGallery"

Get-Module -Name "Az" -ListAvailable

Install-Module -Name "Az" -Repository "PSGallery" -Force

Import-Module -Name "Az"

#endregion Az Module
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Microsoft.PowerShell.SecretManagement Module

Find-Module -Name "Microsoft.PowerShell.SecretManagement" -Repository "PSGallery"

Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable

Install-Module -Name "Microsoft.PowerShell.SecretManagement" -Repository "PSGallery" -Force

Import-Module -Name "Microsoft.PowerShell.SecretManagement"

#endregion Microsoft.PowerShell.SecretManagement Module
#############################################################################################################################################################################

#############################################################################################################################################################################
#region Microsoft.PowerShell.SecretStore Module

Find-Module -Name "Microsoft.PowerShell.SecretStore" -Repository "PSGallery"

Get-Module -Name "Microsoft.PowerShell.SecretStore" -ListAvailable

Install-Module -Name "Microsoft.PowerShell.SecretStore" -Repository "PSGallery" -Force

Import-Module -Name "Microsoft.PowerShell.SecretStore"

#endregion Microsoft.PowerShell.SecretStore Module
#############################################################################################################################################################################

#############################################################################################################################################################################
#region WindowsCompatibilty Module

Find-Module -Name "WindowsCompatibility" -Repository "PSGallery"

Get-Module -Name "WindowsCompatibility" -ListAvailable

Install-Module -Name "WindowsCompatibility" -Repository "PSGallery" -Force

Import-Module -Name "WindowsCompatibility"

#endregion WindowsCompatibilty Module
#############################################################################################################################################################################
