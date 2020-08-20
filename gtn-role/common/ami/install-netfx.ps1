$bucket="({aws.s3.bucket.artifacts})"
$keyPrefix="prerequisites"
$fileName="NDP472-KB4054530-x86-x64-AllOS-ENU.exe"
$targetFolder ="C:\instance_files\netfx"
New-Item $targetFolder -ItemType Directory
Copy-S3Object -BucketName $bucket -key $keyPrefix/$fileName -LocalFile $targetFolder\$fileName
Start-Process -FilePath $targetFolder\$fileName -ArgumentList "/q /norestart /log $targetFolder\netfx-install-log" -Wait