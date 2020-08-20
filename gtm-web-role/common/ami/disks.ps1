function SetupDisk([Int]$diskNumber,[string]$diskLetter,[string]$diskLabal)
{
get-disk $diskNumber | Initialize-Disk -PartitionStyle GPT
New-Partition -DiskNumber $diskNumber -DriveLetter $diskLetter -UseMaximumSize
format-volume -DriveLetter $diskLetter -FileSystem NTFS -AllocationUnitSize 4096 -NewFileSystemLabel $diskLabal
}


SetupDisk 1 "D" "Data" 
