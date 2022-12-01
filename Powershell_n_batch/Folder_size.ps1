$startFolder = "E:\"

$colItems = (Get-ChildItem $startFolder | Measure-Object -Property length -sum)
"$startFolder -- " + "{0:N2}" -f ($colItems.sum / 1MB) + " MB"

$colItems = (Get-ChildItem $startFolder -recurse | ?{$_.PSIsContainer -eq $true}|Sort-Object)
foreach ($i in $colItems){
	Write-Progress -Activity "Folder_size.ps1" -Status "Calculating '$i'"
	$subFolderItems = (Get-ChildItem $i.FullName| Measure-Object -Property length -sum)
	$i.FullName + " -- " + "{0:N2}" -f ($subFolderItems.sum / 1MB) + " MB"
}