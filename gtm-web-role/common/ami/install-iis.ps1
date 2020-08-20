# Enable IIS Web Server and ASP.NET features

Write-Host 'Enabling IIS-WebServerRole'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-WebServerRole
Write-Host 'Enabling IIS-WebServer'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-WebServer
Write-Host 'Enabling IIS-CommonHttpFeatures'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-CommonHttpFeatures
Write-Host 'Enabling IIS-HttpErrors'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-HttpErrors
Write-Host 'Enabling IIS-HttpRedirect'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-HttpRedirect
Write-Host 'Enabling IIS-ApplicationDevelopment'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-ApplicationDevelopment
Write-Host 'Enabling NetFx4Extended-ASPNET45'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName NetFx4Extended-ASPNET45
Write-Host 'Enabling IIS-NetFxExtensibility45'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-NetFxExtensibility45
Write-Host 'Enabling IIS-HealthAndDiagnostics'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-HealthAndDiagnostics
Write-Host 'Enabling IIS-HttpLogging'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-HttpLogging
Write-Host 'Enabling IIS-LoggingLibraries'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-LoggingLibraries
Write-Host 'Enabling IIS-RequestMonitor'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-RequestMonitor
Write-Host 'Enabling IIS-HttpTracing'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-HttpTracing
Write-Host 'Enabling IIS-Security'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-Security
Write-Host 'Enabling IIS-RequestFiltering'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-RequestFiltering
Write-Host 'Enabling IIS-Performance'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-Performance
Write-Host 'Enabling IIS-WebServerManagementTools'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-WebServerManagementTools
Write-Host 'Enabling IIS-IIS6ManagementCompatibility'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-IIS6ManagementCompatibility
Write-Host 'Enabling IIS-Metabase'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-Metabase
Write-Host 'Enabling IIS-ManagementConsole'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-ManagementConsole
Write-Host 'Enabling IIS-BasicAuthentication'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-BasicAuthentication
Write-Host 'Enabling IIS-WindowsAuthentication'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-WindowsAuthentication
Write-Host 'Enabling IIS-StaticContent'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-StaticContent
Write-Host 'Enabling IIS-DefaultDocument'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-DefaultDocument
Write-Host 'Enabling IIS-WebSockets'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-WebSockets
Write-Host 'Enabling IIS-ApplicationInit'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-ApplicationInit
Write-Host 'Enabling IIS-ISAPIExtensions'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-ISAPIExtensions
Write-Host 'Enabling IIS-ISAPIFilter'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-ISAPIFilter
Write-Host 'Enabling IIS-HttpCompressionStatic'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-HttpCompressionStatic
Write-Host 'Enabling IIS-ASPNET45'
Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName IIS-ASPNET45
Write-Host 'Web Server and APS.NET features have been enabled'