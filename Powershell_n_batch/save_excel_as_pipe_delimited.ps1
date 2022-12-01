#requires -version 2
<#
.SYNOPSIS
	Export excel data to a pipe delimited file

.DESCRIPTION
	Export excel data to a pipe delimited file

.PARAMETER None
	

.INPUTS
	Directory, where the excel file/s exist

.OUTPUTS
	A pair of files, one plain csv with same name as the excel 
	and a pipe delimited file with a suffix _pipe.csv

.NOTES
	Version: 		1.0
	Author:			Binil
	Creation Date:	2018
	Purpose/Change:	Initial development

.EXAMPLE
	."\save_excel_as_pipe_delimited.ps1"  "path\"
#>

#---------------------------------------[Initialisation]------------------------------------

#Set error action
$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
. "C:\Scripts\Functions\Logging_Functions.ps1"

#---------------------------------------[Declarations]---------------------------------------

#Script Version
$sScriptVersion = "1.0"

#Resolving Local paths
$Local_folders_n_paths=[enum]::GetNames([System.Environment+SpecialFolder]) `
						|Select @{n="Name";e={$_}}, `
						@{n="Path";e={[environment]::getfolderpath($_)}}
echo "Desktop Path"
echo $($Local_folders_n_paths|?{$_.Name -eq 'Desktop'}).Path

#Log File info
$sLogPath = [environment]::getfolderpath("MyDocuments")
$sLogName = "$((get-date).toString('yyyy-MM-dd-HH-mm-'))<script_name>.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#--------------------------------------[Function]---------------------------------------------

<#

Function <FunctionName>{
	Param()
	Begin{
		Log-Write -LogPath $sLogFile -LineValue "<Message>"
	}

	Process{
		Try{
			<Code goes here>
		}

		Catch{
			Log-Error -LogPath $sLogFile -ErrorDesc $_.Exception -ExitGracefully $True
		}
	}

	End{
		If($?){
			Log-Write -LogPath $sLogFile -LineValue "Completed successfully"
			Log-Write -LogPath $sLogFile -LineValue " "
		}
	}
}
#>


#------------------------------------[Execution]--------------------------------------------

#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
# <Script execution goes here>
#Log-Finish -LogPath $sLogPath -LogName $sLogName

$file_path=$Args[0]
echo '$file_Path:'$file_Path
if(Test-path $file_path)
{
	$xlCSV = 6
	$xlsFiles = $(get-childitem ${file_path}* -include *xls, *xlsx)
	#echo '$Args:'$Args[0]
	echo '$xlsFiles:'$xlsFiles
	
	if ($xlsFiles){
		Foreach ($ExcelFile in $xlsFiles){
			echo '$ExcelFile:'$ExcelFile
			$BaseFileName = $ExcelFile.BaseName
			$BaseDir = $ExcelFile.Directory
			$CSVFile = "$BaseDir\$BaseFileName.csv"
			echo '$CSVFile:'$CSVFile
			
			#$Excel = $(New-Object -comobject Excel.Application -Delimiter "|")
			$Excel = $(New-Object -comobject Excel.Application )
			#echo '$Excel:'$Excel 
			$Excel.Visible = $false
			$Excel.DisplayAlerts = $false
			$Workbook = $Excel.Workbooks.open($ExcelFile)
			
			$Workbook.SaveAs($CSVFile,$xlCSV)
			echo '$Workbook:'$Workbook
			import-csv $CSVFile|export-csv -notypeinformation -delimiter "|" "$BaseDir\${BaseFileName}_pipe.csv"
			#mv $ExcelFile $BaseDir\Spreadsheets
			$Excel.Quit()
			
			if(ps excel) {kill -name excel}
		}
		
	}
} else {
	write-error "$Args is not a valid path"
	#echo "$Args is not a valid path"
}
