$bucket = "({aws.s3.bucket.artifacts})"
$keyPrefix = "prerequisites"
$fileName = "sqlncli.msi"
$targetFolder = "C:\instance_files\sqlncli"
New-Item $targetFolder -ItemType Directory
Copy-S3Object -BucketName $bucket -key $keyPrefix/$fileName -LocalFile $targetFolder\$fileName
msiexec.exe /i $targetFolder\$fileName /quiet /l $targetFolder\install.log IACCEPTSQLNCLILICENSETERMS=YES