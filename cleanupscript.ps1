# List the users in c:\users to csv
dir C:\Users | select Name | Export-Csv -Path C:\users\$env:USERNAME\users.csv -NoTypeInformation
$list=Test-Path C:\users\$env:USERNAME\users.csv

#Clearing IE cache
Import-CSV -Path C:\users\$env:USERNAME\users.csv | foreach {
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Microsoft\Windows\Temporary Internet Files\*" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Microsoft\Windows\WER\*" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\Windows\Temp\*" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\`$recycle.bin\" -Recurse -Force -EA SilentlyContinue -Verbose
}

#clearing chrome cache
Import-CSV -Path C:\users\$env:USERNAME\users.csv -Header Name | foreach {
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache\*" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cache2\entries\*" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Media Cache" -Recurse -Force -EA SilentlyContinue -Verbose
Remove-Item -path "C:\Users\$($_.Name)\AppData\Local\Google\Chrome\User Data\Default\Cookies-Journal" -Recurse -Force -EA SilentlyContinue -Verbose
}

#Delete temp files and folders and downloads
Import-CSV -Path C:\users\$env:USERNAME\users.csv | foreach {
$tempfolders = @("C:\Windows\Temp\*", "C:\Documents and Settings\*\Local Settings\temp\*", "C:\Users\*\Appdata\Local\Temp\*", "C:\Users\*\Downloads\*")
Remove-Item $tempfolders -Recurse -Force -EA SilentlyContinue -Verbose
}


#Empty Recycle Bin
Import-CSV -Path C:\users\$env:USERNAME\users.csv | foreach {
$Shell = New-Object -ComObject Shell.Application
$RecBin = $Shell.Namespace(0xA)
$RecBin.Items() | %{Remove-Item $_.Path -Recurse -Confirm:$false}
}


Restart-Computer


