#--------------------------------------------------------------------
# This script deploys all OGT application components to EC2
# and sets all required environment variables
#--------------------------------------------------------------------

$Script:bucket = '({aws.s3.bucket.artifacts})'
$Script:keyPrefix = '({server.role})'

$Script:tempDir = "$env:TEMP"
$Script:site = 'Default Web Site'
$Script:webServiceRootPath = 'D:\webservices'
$Script:winServiceRootPath = 'D:\services'
$Script:sharedReferencesPath = 'D:\webZ\FTZLink.net\References'
$Script:webSitePath = 'D:\webZ\FTZLink.net\FTZLink'
$reportLibraryPath = 'D:\IntegrationPoint\ReportLibrary'

[System.Environment]::SetEnvironmentVariable('OGT_CLOUD', 'Y', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('OGT_BRANCH_LABEL', 'master', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('OGT_SERVER_ROLE', 'gtm-web', [System.EnvironmentVariableTarget]::Machine)
#[System.Environment]::SetEnvironmentVariable('OGT_CONFIG_SERVER_URL', '({app.config.server.url})', [System.EnvironmentVariableTarget]::Machine)

$username = "NT AUTHORITY\NETWORK SERVICE"
$password = convertto-securestring -String "Admin" -AsPlainText -Force  
$credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $username, $password

Import-Module WebAdministration -ErrorAction SilentlyContinue

$ErrorActionPreference = 'Stop'

# Downloads package from S3 and extracts it to specified target folder
function DownloadPackage([string] $package, [string] $dirName) {
  Write-Host "Downloading $package package from S3"
  Copy-S3Object -BucketName $Script:bucket -KeyPrefix $Script:keyPrefix -LocalFolder $tempDir\ 
  Write-host "Extracting $packageName to dirName"
  New-Item $dirName -ItemType Directory
  Expand-Archive $Script:tempDir\$package -DestinationPath $dirName
  Remove-Item $Script:tempDir\$package -Recurse
}

# Creates IIS Virtual Web Directory from specified S3 package
function CreateWebApp([string] $dirName, [string] $package, [string] $appPool) {
  $webServicePath = "$Script:webServiceRootPath\$dirName"
  DownloadPackage $package $webServicePath 
  Write-Host "Creating IIS Virtual Directory $dirName"
  New-WebApplication -Site $Script:site -Name $dirName -PhysicalPath $webServicePath -ApplicationPool $appPool -Force
}

# Creates Windows Service from specified S3 package
function CreateWinService([string] $svcName, [string] $package) {
  $winServicePath = "$Script:winServiceRootPath\$svcName"
  DownloadPackage $package $winServicePath
  Write-Host "Creating Windows Service $svcName"
  New-Service -Name "$svcName" -BinaryPathName "$winServicePath\$svcName.exe" -DisplayName "$svcName" -StartupType Manual -Credential $credential
  sc.exe failure "$svcName" reset= 3600 actions= restart/60000/restart/300000/reboot/60000
}

# Creates Windows Service in specified folder
function CreateWinServiceInPath([string] $svcName, [string] $path) {
  Write-Host "Creating Windows Service $svcName" 
  New-Service -Name "$svcName" -BinaryPathName "$path\$svcName.exe" -DisplayName "$svcName" -StartupType Manual -Credential $credential
  sc.exe failure "$svcName" reset= 3600 actions= restart/60000/restart/300000/reboot/60000
}

#--------------------------------------------------------------------
# Web Site / IIS
#--------------------------------------------------------------------

DownloadPackage gtm-web.zip $Script:webSitePath

[System.Version]$ver = [System.Diagnostics.FileVersionInfo]::GetVersionInfo("$($Script:webSitePath)\bin\gtm.dll").FileVersion

# Configured "Default Web Site" to use this path.
Set-ItemProperty "IIS:\Sites\$site\" -name physicalPath -value $Script:webSitePath
Set-ItemProperty "IIS:\Sites\$site\" -name logFile.directory -value "D:\Logs\IIS"

# Set-Service -Name W3SVC -StartupType Manual
# sc.exe config W3SVC start=delayed-auto

#--------------------------------------------------------------------
# Web Services
#--------------------------------------------------------------------

New-WebAppPool WebServicePool

CreateWebApp	ABI abi-web.zip WebServicePool
CreateWebApp	BiblioWebService biblio-web.zip WebServicePool
CreateWebApp	CompanySyncWS company-sync-web.zip WebServicePool
CreateWebApp	DTSWebservice dts-web.zip WebServicePool
CreateWebApp	ExportWS export-web.zip WebServicePool
CreateWebApp	InboundClientWebService inbound-client-web.zip WebServicePool
CreateWebApp	IPAPI ipapi-web.zip WebServicePool
CreateWebApp	ItemMasterWebServices item-master-web.zip WebServicePool
CreateWebApp	MXZoneWebService mx-zone-web.zip WebServicePool
CreateWebApp	PETROABI petro-abi-web.zip WebServicePool
CreateWebApp	ProdClassWebServices prod-class-web.zip WebServicePool
CreateWebApp	SSO sso-web.zip WebServicePool
if( $ver.CompareTo([System.Version]::Parse("20.3")) -ge 0 ) {
  CreateWebApp	AuthenticationService TR.OGT.AuthenticationService.zip WebServicePool
  CreateWebApp	MenuService TR.OGT.MenuService.zip WebServicePool
}

# CreateWebApp	ContentExtractorWS content-extractor-web.zip WebServicePool
# CreateWebApp	ContentWebService content-web2.zip WebServicePool
# CreateWebApp	ContentWebServices content-web.zip WebServicePool
# CreateWebApp	ContentWS content-web3.zip WebServicePool
# CreateWebApp	eRequestWS e-request-web.zip WebServicePool
# CreateWebApp	MarketingWS marketing-web.zip WebServicePool
# CreateWebApp	SubscriptionMaintenanceWS sub-maint-web.zip WebServicePool
# CreateWebApp	USABIWebservice us-abi-web.zip WebServicePool

#--------------------------------------------------------------------
# Shared references
#--------------------------------------------------------------------

DownloadPackage SharedReferences.zip $Script:sharedReferencesPath

#--------------------------------------------------------------------
# Windows Services
#--------------------------------------------------------------------

New-EventLog -Source IPEventBuffer -LogName Application

CreateWinService IPEventBuffer event-buffer-svc.zip
CreateWinServiceInPath ipMonitorService $Script:sharedReferencesPath

# CreateWinService IPLocalLogBuffer local-log-buffer-svc.zip
# CreateWinServiceInPath 'IP Log Mover Service' $Script:sharedReferencesPath
# CreateWinServiceInPath 'IP Session Clean Up Service' $Script:sharedReferencesPath
# CreateWinServiceInPath ipKnowledgePostService $Script:sharedReferencesPath
# CreateWinServiceInPath ipResultFileStorageService $Script:sharedReferencesPath

#--------------------------------------------------------------------
# Reports Library
#--------------------------------------------------------------------

DownloadPackage report-library.zip $reportLibraryPath

#--------------------------------------------------------------------
# Working Folders
#--------------------------------------------------------------------

New-Item D:\IntegrationPoint\Storage\Attachments -ItemType Directory
New-Item D:\IntegrationPoint\Storage\DTS -ItemType Directory
New-Item D:\IntegrationPoint\Storage\Reports -ItemType Directory
New-Item D:\IntegrationPoint\Storage\Temp -ItemType Directory

New-Item D:\Temp -ItemType Directory

New-Item D:\WebZ\FTZLink.net\FTZLink\MXZone\Temp
$path = "D:\WebZ\FTZLink.net\FTZLink\TEMP"
If(!(test-path $path))
{
      New-Item -ItemType Directory -Force -Path $path
}