$bucket = "({aws.s3.bucket.artifacts})"
$keyPrefix = "prerequisites"
$fileName = "crystalreports.msi"
$targetFolder = "C:\instance_files\crystalreports"
New-Item $targetFolder -ItemType Directory
Copy-S3Object -BucketName $bucket -key $keyPrefix/$fileName -LocalFile $targetFolder\$fileName
msiexec.exe /i $targetFolder\$fileName /quiet /l $targetFolder\crystalreports.log