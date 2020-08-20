$logName = 'Application'
$logSource = 'EC2-Bootstrap'

New-EventLog -LogName $logName -Source $logSource

# Set Time zone to Eastern Standard Time
Write-EventLog -LogName $logName -Source $logSource -EventID 10001 -EntryType Information -Category 1 -Message 'Setting TimeZone'
tzutil /s "Eastern Standard Time"

# Enable DataDog
Write-EventLog -LogName $logName -Source $logSource -EventID 10001 -EntryType Information -Category 1 -Message 'Enabling DataDog'
(Get-Content C:\ProgramData\Datadog\datadog.yaml -raw).Replace("process_config:`n  enabled: `"false`"", "process_config:`n  enabled: `"true`"") | Set-Content C:\ProgramData\Datadog\datadog.yaml
$key = (Get-SSMParameter -Name /a205822/datadog/trta-onesource -WithDecryption $true).Value
& "C:\instance_files\datadog\activate_datadog_agent.ps1" $key

# Set OGT environment variables from EC2 tags
Write-EventLog -LogName $logName -Source $logSource -EventID 10001 -EntryType Information -Category 1 -Message 'Setting Environment Variables'
$instanceId = Get-EC2InstanceMetadata -Category InstanceId
[System.Environment]::SetEnvironmentVariable('EC2_INSTANCE_ID', $instanceId, [System.EnvironmentVariableTarget]::Machine)
$environment = Get-EC2Tag -Filter @{ Name='key';Value='tr:environment-name'},@{ Name='resource-id';value=$instanceId} | Select-Object -ExpandProperty Value
[System.Environment]::SetEnvironmentVariable('OGT_ENVIRONMENT', $environment, [System.EnvironmentVariableTarget]::Machine)
Write-EventLog -LogName $logName -Source $logSource -EventID 10001 -EntryType Information -Category 1 -Message "OGT_ENVIRONMENT: $environment"
$configUrl = Get-EC2Tag -Filter @{ Name='key';Value='tr:app-config-url'},@{ Name='resource-id';value=$instanceId} | Select-Object -ExpandProperty Value
[System.Environment]::SetEnvironmentVariable('OGT_CONFIG_SERVER_URL', $configUrl, [System.EnvironmentVariableTarget]::Machine)
Write-EventLog -LogName $logName -Source $logSource -EventID 10001 -EntryType Information -Category 1 -Message "OGT_CONFIG_SERVER_URL: $configUrl"

# Starting Services
Write-EventLog -LogName $logName -Source $logSource -EventID 10001 -EntryType Information -Category 1 -Message 'Restarting IIS'
iisreset /noforce

Write-EventLog -LogName $logName -Source $logSource -EventID 10001 -EntryType Information -Category 1 -Message 'Starting Windows Services'
Start-Service -Name IPEventService
Start-Service -Name IPDocumentService
