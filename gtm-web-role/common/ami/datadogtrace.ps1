$bucket = "({aws.s3.bucket.artifacts})"
$keyPrefix = "prerequisites"
$fileName = "datadog-dotnet-apm-1.16.0-x64.msi"
$targetFolder = "C:\instance_files\datadogtrace"
New-Item $targetFolder -ItemType Directory
Copy-S3Object -BucketName $bucket -key $keyPrefix/$fileName -LocalFile $targetFolder\$fileName
msiexec.exe /i $targetFolder\$fileName /quiet /l $targetFolder\datadpgtrace.log