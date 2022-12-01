## Registry listing
gci "HKCU:Software\Odbc\Odbc.ini"

## Find line number with pattern match
gc file_name.txt|sls -pattern "pattern" |select-object -exapandproperty 'linenumber'

## Look for file or directory in a folder
$(ls)  -match "pattern"
$(gci) -match "pattern"

## Files containig a string
select-string -pattern "pattern" -path "dir\*txt" |Select-object -Unique Path

## Search a bunch of files for a value and get result by  file name
#  How it work?
#  Print contents of all files in current path
#  Name of the file printed is available in variable $_.PSPath
#  sls command find the lines matching pattern
#  echo command put it together
cat *|%{$file=$_.PSPath;if($lines=$_|sls -pattern 'pattern') {echo "$file - $lines"}}

# get-childItem(gci) is equivalent to cat
gci . -include "*.sql" -recurse `
    | select-string -pattern 'pattern' `
    | Format-table -GroupBy Path


# If only file names are needed
gci . -include "*.sql" -recurse `
    | select-string -pattern 'pattern' `
    | Select-object -Unique Path

# For getting lines before and after
cat . |sls -pattern 'pattern' -context 5

# Only Selected column from matched lines

gci delimited_file.txt `
    | select-string -pattern 'pattern' `
    | ConvertFrom-csv -header 1,Secon_col_nm -delimiter "|" `
    | Select-String 1,Secon_col_nm `
    | out-file \path\file -width 500

 
##############################
##  Formating and filtering ##
##############################

## Files by date
gci .|where-object {$_.LastWriteTime -gt "3/11/2015" -and $_.LastWriteTime -lt "3/12/2015"}

gci 'PATH' -recurse -include @("*.tif","*.jpg","*.pdf") `
	| select-object FullName, CreationTime, `
	@{Name="MBytes";Expression={(((Get-Date) - $_CreationTime).Days)}} `
	| sort -property MBytes -descending `
	| Export-csv -notype "Target\path\file"

## Share folder Analysis ###
gci \\share\folder\root\ -recurse `
	|where-object {$_.LastWriteTime -lt ((Get-date).AddMonths(-1)) `
		-and $_.Length -gt 10MB} `
	|select-object FullName, CreateTime, @{Name="MBytes";`
		Expression={(((Get-Date) - $_CreationTime).Days)}} `
	|sort -property MBytes -descending 

## Analysis of multiple locations ##
$('location1','location2','location3',) `
	|% -begin {$timestamp=$((get-date).toString('-yyyy-MM-dd-HH-mm'))} `
	   -process {gci \\share\folder\$_\ -recurse `
		|where-object {$_.LastWriteTime -lt ((Get-date).AddMonths(-1)) `
			-and $_.Length -gt 10MB} `
		|select-object FullName, CreateTime,@{Name="MBytes"; `
			Expression={(((Get-Date) - $_CreationTime).Days)}} `
		|sort -property MBytes -descending }
 
## Directories with latest updates
### ?{} is shortcut for where-objects{}
gci -Recurse -Directory |?{$_.lastwritetime -gt "11/14/2016"} `
	|sort -property lastwritetime -desc `
	|select-object Fullname, lastwritetime `
	|export-csv \\dir\file_name

## Selecting regex sub pattern ##
### %{} is shortcut for foreach{}
<#
$_.Matches Variable is a collection of following
Groups	: {859-05:00, -05:00}
Success : True
Captures: {859-05:00}
Index	: 2445
Length  : 9
Value	: 859-05:00
#>

sls -path "file_name" -pattern "[0-9]{3,}(-[0-9]{2,}:00)" -allmatches `
	|%{$_.matches}|%{$_.groups[1]}|%{$_.value}|select-object -unique


<## XML Parsing ###
===================
# Following command will extract XML node <LegalEntityRegion>ALABAMA</LegalEntityRegion>
#>
ls |%{$file=$_.PSChildName;$state=$(sls -path $file -pattern 'LegalEntityRegion>ALABAMA</LegalEntityRegion' `
	|%{$_.matches}|%{$_.groups[1]}|%{$_.value}); "$file|$state"}

## Web services ###
#===================

Invoke-WebRequest -uri $url|%{$_.Forms[0]}|ForEach{$_.Fields}

<#List all Objects recusrsively
-recurse- List all objects recursively
-name	- Only Names will be listed
-force	- List hidden files too
#>

gci -recurse -name -force >"result.txt"

#Count of Records for each files
#===============================

#With Title
$FileData=@();gci C:\Windows *.txt `
	|%{$FileData += New-Object PSObject -Property @{'FileName'=$_.Name; `
		'Total Lines'=(Get-Content $_.FullName).Count} `
		}
# No Title
gci . *.txt|%{ $_.Name+" - "+(Get-Content $_.FullName).Count}

#Multi line search REGEX
#========================

$fileContent = get-content file.txt -Raw
#OR
$fileContent = [io.file]::ReadAllText("file.txt")

$fileContent|Select-String '(?smi) regex_pattern' -AllMatches |%{$_.Matches}|%{$_.Values}

#XML search for Multiline sections

ls -File|%{if(gc $_ -Raw|sls '(?sm)\<\/OpenTag\>\s+\<\/CloseTag\>' -quite) `
	{echo "File $_ has the pattern"} else {echo "File $_ does not have pattern"}}
# Unique tables used in a query #
# =============================
# Teradata sql expression like extract(year/month.. from date/datetime) will also be included
(gc query_file.txt -raw| sls -pattern "(from|join)[\s$]+[\w\.]+" -allmatches `
	|%{$_.Matches}|%{$_.Value}) -replace "(FROM|JOIN)\s+",""|select-object -uniq


(gc query_file.txt -raw| sls -pattern "(from|join)[\s$]+([\w\.]+)" -allmatches `
	|%{$_.Matches}|%{$_.groups[2]}|%{$_.Value.trim()})|select-object -uniq

$(gc query_file.txt) -join " "| sls -pattern "(from|join)[\s$]+([\w\.]+)" -allmatches `
	|%{$_.Matches}|%{$_.groups[2]}|%{$_.Value.trim()}|select-object -uniq

# Find duplicates
# ===============
# Reads multiple files and find duplicates based on select columns

ls -File Name* |%{import-csv -path $_ -header 1,Col_2,3,4,5,Col_6 -delimiter "|" `
	|select Col_2,Col_6}|group-object Col_2|?{$_.count -gt 1}|%{$_.Name}

ls -File Name* |%{import-csv -path $_ -header 1,Col_2,3,4,5,Col_6 -delimiter "|" `
	|select Col_2,Col_6}|sort

## Replace commands
# =================

## Replacing text in Strings and files
"Text    with   extra     spaces" -replace "\s+"," " 
#output will be "Text with extra spaces"
(gc -Path C:\path\file.txt ) -replace "\s+"," " >C:\path\cleaned\


## Renaming files
get-childitems -pattern "*.txt"|rename-item -newname {$_.name -replace "^","NewBeginning-"}

<#
This command  is used extract neighboring check points from MLOAD log files

This was to find cases when check point take longer than an hour
This will consider only minute parts of timestamps
As the command scans multiple files file name is also checked along with timestamp

Both lines checked are printed in case of a match

**** marks a record with a check point. But * is a wild card too
Due to this -simplematch option is used
#>


gci C:\path\ -include "*.ldrlog" -recurse|select-string -pattern "****" -simplematch `
	|% -begin{$reg=[regex]':(\d\d):'} `
	   -process {$catch=$reg.Match($_); $time1=$catch.Groups[1].value; `
			if ([int]($time1-$time2) -igt 2 -and $_.path -eq $prev_path) `
				{echo $prev_line; echo $_}; `
			$time2=$time1; $prev_path=$_.path; $prev_line=$_}


## Sample from large file
get-content Large_file.txt -last 200

## Opening multiple CSV Files
get-content Files*.csv|%{$_.PSChildname+","+$_}|out_file C:\path\combined_file.csv

<#
PSChildName has file name
output will have file name prefixed to each line
#>

##URLs and Web service
# =====================

# Validating URLs

cat "C:\path\file_with_urls.txt"|% -begin{$log_file="C:\log_path\URL_LOG.log"} `
	-process {TRY{$url=$_; echo $url|out-file -append -filepath $log_file; `
			$request=invoke-webrequest $url|out-file -append -filepath $log_file;} `
		  CATCH [System.Net.WebException]{echo $url+"--"$error[0].exception
		  	|out-file -append -filepath $log_file;} `
		  FINALLY {$ErrorActionPreference = "CONTINUE";} `
		  }
## Webservice call
invoke-webrequest "URL" -infile Request_XML.xml -contentType "text/xml" -method POST `
	-Headers @{"SOAPAction" = "service=SERVICE_NAME"}


## Fixed width formatting
$s ='barbarbar'
$len =[math]::Min(7, $s.Length)
'_{0,-5}:{1,-7}:{2,-9}_' -f 'foo',$s.Substring(0,$len),'baz'

<#output will be _foo  :barbarb:baz      _
{0,-5} - 0th input will be left aligned with width 5 with space padding
{1,-7} - 1st input will be left aligned with width 7. last two chars will be truncated
{2,-9} - 2nd input will be left alinged with width 9 with space padding
#>

#Send email
# No password storage
send-mailmessage -to receipient@company.com "Subject goes here" -body "Mail body here" `
	-smtpserver smtp.office365.com -from sender@company.com `
	-credential $(get-credential) -port 587 -usessl

#With password storage
$(get-credential)|Export-CliXML C:\Path\cred.xml
send-mailmessage -to receipient@company.com "Subject goes here" -body "Mail body here" `
	-smtpserver smtp.office365.com -from sender@company.com `
	-credential $(Import-CliXML C:\Path\cred.xml) -port 587 -usessl

## This credential can be exposed like this
[System.Runtime.InteropServices.Marshal]::PtrToStringAuto( `
[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR( `
$(Import-CliXML C:\Path\cred.xml).password))


### Informatica Session Log based analysis
# =========================================

#gci or search can be used
gci C:\path\ -recurse|sls -pattern 'TPTWR_' -list|select-object -uniq path `
	|%{$logpath=$_.path.trim(); `
          $folder=$(sls -pattern 'TM_6686.*Folder: \[(\w*)\].*' -path $logpath `
	      |%{$_.Matches}|%{$_.groups[1]}|%{$_.Value});
	  $wf=$(sls -pattern 'TM_6685.*Workflow: \[(\w*)\].*' -path $logpath `
	  	|%{$_.Matches}|%{$_.groups[1]}|%{$_.Value});
	  $sess=$(sls -pattern 'TM_6014.*session: \[(\w*)\].*' -path $logpath `
	  	|%{$_.Matches}|%{$_.groups[1]}|%{$_.Value}); `
	  $logpath+","+$folder+","+$wf+","+$sess} 


search pattern1.*pattern2.* |sls -pattern 'TPTWR_' -list|select-object -uniq path `
	|%{$logpath=$_.path.trim(); `
	   $folder=$(sls -pattern 'TM_6686.*Folder: \[(\w*)\].*' -path $logpath `
	   	    ).Matches.groups[1].Value; `
           $wf=$(sls -pattern 'TM_6685.*Workflow: \[(\w*)\].*' -path $logpath `
	        ).Matches.groups[1].Value; `
	   ($x,$sess,$start)= `
	   $(sls -pattern 'TM_6014.*session: \[([\w\s]+)\][\w\s]+\[([\w:\s]+)\]\.' `
	   	-path $logpath).Matches.groups; `
	   $end=$([datetime]::ParseExact((sls -pattern 'TM_6020.+\[([\w:\s]*)\].'  `
	   	-path $logpath).Matches.groups[1].Value,'ddd MMM dd hh:mm:ss yyyy',$null )); `
	   $start_t=$([datetime]::ParseExact($start,'ddd MMM dd hh:mm:ss yyyy',$null )); `
	   $elapsed=$($end-$start_t); `
	   $logpath+","+$folder+","+$wf+","+$sess+","+$start_t+","+$end+","+$elapsed} 

## Conditional copy of files to another dir
# =========================================
#

ls pattern*|? lastwritetime -gt '9/9/2016'|%{copy $_.fullname C:\target\dir}

## Zip file
# List files
#
[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem'); `
[IO.Compression.ZipFile]::OpenRead(C:\location\file.zip).Entries.FullName

## JSON
#==============
# {"name":"Sample","children":[{"name":"circle1","size":15},{"name":"circle2","size":17},{"name":"circle3","size":25},{"name":"circle4","size":75},{"name":"circle5","size":35}]}

# To Display on the screen
cat file_nm.json|convertfrom-json|%{$_.children}

# To write the parsed data to a file
cat file_nm.json|convertfrom-json|%{$_.children}|convertTo-csv|out-file json-to-csv.txt

