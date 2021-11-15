#requires -PSEdition Desktop

Configuration HostConfiguration {
    #region DSC Resources
    Import-DscResource -ModuleName "PSDscResources"
    Import-DscResource -ModuleName "xHyper-V"
    #endregion DSC Resources

    Node "localhost" {
        #region All Nodes
        @("DC01", "SQL01", "WEB01") | ForEach-Object {
            xVHD "xVHD$_" {
                Ensure           = "Present"
                Generation       = "VHDX"
                MaximumSizeBytes = $Node.MaximumSizeBytes
                Name             = $_
                Path             = $Node.VirtualHardDisksPath
            }
            xVMHyperV "xVMHyperV$_" {
                AutomaticCheckpointsEnabled = $false
                DependsOn                   = "[xVHD]xVHD$_"
                EnableGuestService          = $true
                Ensure                      = "Present"
                MinimumMemory               = $Node.MinimumMemory
                Name                        = $_
                ProcessorCount              = $Node.ProcessorCount
                SwitchName                  = "Default Switch"
                VhdPath                     = Join-Path -Path $Node.VirtualHardDisksPath -ChildPath "$_.vhdx"
            }
            xVMDvdDrive "xVMDvdDrive$_" {
                ControllerLocation = 0
                ControllerNumber   = 1
                DependsOn          = "[xVMHyperV]xVMHyperV$_"
                Ensure             = "Present"
                Path               = $Node.WindowsServerIsoPath
                VMName             = $_
            }
        }
        #endregion All Nodes

        #region SQL Server Node
        xVMDvdDrive "xVMDvdDrive$_" {
            ControllerLocation = 1
            ControllerNumber   = 1
            DependsOn          = "[xVMHyperV]xVMHyperVSQL01"
            Ensure             = "Present"
            Path               = $Node.SqlServerIsoPath
            VMName             = "SQL01"
        }
        #endregion SQL Server Node
    }
}