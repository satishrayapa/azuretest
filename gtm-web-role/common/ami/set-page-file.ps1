#--------------------------------------------------------------------
# This script sets Windows page (swap) file size
#--------------------------------------------------------------------

Write-Host 'Disabling Automatic Managed Page File'
$computersys = Get-WmiObject Win32_ComputerSystem -EnableAllPrivileges
$computersys.AutomaticManagedPagefile = $False
$computersys.Put()

Write-Host 'Setting Page File Size to 4 GB'
$pagefile = Get-WmiObject -Query "Select * From Win32_PageFileSetting Where Name like '%pagefile.sys'"
$pagefile.InitialSize = 4096
$pagefile.MaximumSize = 4096
$pagefile.Put()