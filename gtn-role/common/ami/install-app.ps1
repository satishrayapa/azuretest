#--------------------------------------------------------------------
# This script deploys all OGT application components to EC2
# and sets all required environment variables
#--------------------------------------------------------------------

$Script:bucket = '({aws.s3.bucket.artifacts})'
$Script:keyPrefix = '({server.role})'

$Script:targetPath = 'D:\webservices'
$Script:tempDir = "$env:TEMP"
$Script:site = 'Default Web Site'

[System.Environment]::SetEnvironmentVariable('OGT_CLOUD', 'Y', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('OGT_BRANCH_LABEL', 'latest', [System.EnvironmentVariableTarget]::Machine)
[System.Environment]::SetEnvironmentVariable('OGT_SERVER_ROLE', 'gtn', [System.EnvironmentVariableTarget]::Machine)
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
  
  Write-host "Extracting $packageName to $Script:targetPath"
  New-Item $Script:targetPath\$dirName -ItemType Directory
  Expand-Archive $Script:tempDir\$package -DestinationPath $Script:targetPath\$dirName
  Remove-Item $Script:tempDir\$package -Recurse
}

# Downloads package from S3 and extracts it to specified target folder for services
function DownloadPackageSvc([string] $package, [string] $svcName) {
  Write-Host "Downloading $package package from S3"
  Copy-S3Object -BucketName $Script:bucket -KeyPrefix $Script:keyPrefix -LocalFolder $tempDir\
  
  Write-host "Extracting $packageName to $Script:targetPath"
  New-Item $Script:targetPath\$svcName -ItemType Directory
  Expand-Archive $Script:tempDir\$package -DestinationPath $Script:targetPath\$svcName
  Remove-Item $Script:tempDir\$package -Recurse
}

# Creates IIS Virtual Web Directory from specified S3 package
function CreateWebApp([string] $dirName, [string] $package) {
  DownloadPackage $package $dirName 

  Write-Host "Creating IIS Virtual Directory $dirName"
  New-WebApplication -Site $Script:site -Name $dirName -PhysicalPath $Script:targetPath\$dirName -Force
}

# Creates Windows Service from specified S3 package
function CreateWinService([string] $svcName, [string] $package) {
  DownloadPackageSvc $package $svcName 
  Write-Host "Creating Windows Service $svcName" 
  New-Service -Name "$svcName" -BinaryPathName "$Script:targetPath\$svcName\$svcName.exe" -DisplayName "$svcName" -StartupType Manual -Credential $credential
  sc.exe failure "$svcName" reset= 3600 actions= restart/60000/restart/300000/reboot/60000
}

CreateWebApp DocDBReader documentdb-reader-web.zip
CreateWebApp DocDBWriter documentdb-writer-web.zip
CreateWebApp EventDBReader eventdb-reader-web.zip
CreateWebApp EventDBWriter eventdb-writer-web.zip
# CreateWebApp LogDBReader logdb-reader-web.zip
# CreateWebApp LogDBWriter logdb-writer-web.zip

New-EventLog -Source IPDocumentService -LogName Application
New-EventLog -Source IPEventService -LogName Application

CreateWinService IPDocumentService document-svc.zip
CreateWinService IPEventService event-svc.zip
# CreateWinService IPLogDBLoader logdb-loader-svc.zip