$FileData=@();
Get-ChildItem *.ps1|%{ $FileData += New-Object PSObject -Property `
@{'FileName'=$_.Name;'Total Lines'=(Get-Content $_.FullName).Count}}
$FileData