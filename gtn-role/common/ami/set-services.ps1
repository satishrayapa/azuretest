#--------------------------------------------------------------------
# This script enables  / disables various OS services
#--------------------------------------------------------------------

Write-Host 'Disabling Program Compatibility Assistant Service Service' 
Set-Service -Name PcaSvc -StartupType Disabled

Write-Host 'Disabling Diagnostic System Host Service' 
Set-Service -Name WdiSystemHost -StartupType Disabled

Write-Host 'Disabling Microsoft Account Sign-in Assistant Service' 
Set-Service -Name wlidsvc -StartupType Disabled

Write-Host 'Disabling Update Orchestrator Service for Windows Update'
Set-Service -Name UsoSvc -StartupType Disabled

Write-Host 'Disabling Windows Update Service' 
Set-Service -Name wuauserv -StartupType Disabled

$svcName = Get-Service -Name CDPUserSvc_* | Select-Object -ExpandProperty Name
if (-not [string]::IsNullOrEmpty($svcName)) {
    Write-Host 'Disabling CDPUserSvc_xxxx Service' 
    Set-Service -Name $svcName -StartupType Disabled
}

# Disable Trend Micro

#Write-Host 'Disabling Trend Micro Solution Platform Service' 
#Set-Service -Name Amsp -StartupType Disabled

#Write-Host 'Disabling Trend Micro Deep Security Agent Service' 
#Set-Service -Name ds_agent -StartupType Disabled

#Write-Host 'Disabling Trend Micro Deep Security Monitor Service' 
#Set-Service -Name  ds_monitor -StartupType Disabled

#Write-Host 'Disabling Trend Micro Deep Security Notifier Service' 
#Set-Service -Name ds_notifier -StartupType Disabled

#Write-Host 'Removing Trend Micro Enablement Task' 
#Unregister-ScheduledTask 'Enable Deep Security Agent' -Confirm:$False