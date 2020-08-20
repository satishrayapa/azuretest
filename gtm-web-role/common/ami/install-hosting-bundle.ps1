$bucket = "({aws.s3.bucket.artifacts})"
$keyPrefix = "prerequisites"
$fileName = "dotnet-hosting-2.2.8-win.exe"
$targetFolder = "C:\instance_files\hostingbundle"
New-Item $targetFolder -ItemType Directory
Copy-S3Object -BucketName $bucket -key $keyPrefix/$fileName -LocalFile $targetFolder\$fileName
& $targetFolder\$fileName /install /quiet /norestart /log $targetFolder\hostingbundle.log