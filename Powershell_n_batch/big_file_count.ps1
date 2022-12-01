$count=0
$reader= new-object IO.StreamReader "E:\Binil\Cognizant Codes\big_file_count.ps1"
while($reader.readLine() -ne $null) { $count++ }
$reader.Close
$count