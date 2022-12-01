#requires -version 2
<#
.SYNOPSIS
	Script that can split large files

.DESCRIPTION
	This script split large files based on line count.
	This was based on stack overflow reponses by Vincent De Smet and Typhlosaurus
	https://stackoverflow.com/questions/1001776/how-can-i-split-a-text-file-using-powershell

.PARAMETER <Parameter names>
	<Description of parameters used. Repeat for each parameters>

.INPUTS
	<Inputs if any, Otherwise state None>

.OUTPUTS
	<Outputs if any, Otherwise state None - Example: Log file stored in C:\Windows\Temp\<name>.log>

.NOTES
	Version: 		1.0
	Author:			<Name>
	Creation Date:	<Date>
	Purpose/Change:	Initial development

.EXAMPLE
	<Example goes here. Repeat for each examples>
#>
echo "test"

#---------------------------------------[Initialisation]------------------------------------

#Set error action
$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
#. "C:\Scripts\Functions\Logging_Functions.ps1"

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

$sw = new-object System.Diagnostics.Stopwatch
$sw.start()
$filename="E:\winemag-data_first150k3ed116a.csv"
$outputPath="E:\Binil\Cognizant Codes\output\"
$ext="txt"

$linesPerFile=10000#10k
$filecount = 1
$reader = $null

#------------------------------------[Execution]--------------------------------------------

#Log-Start -LogPath $sLogPath -LogName $sLogName -ScriptVersion $sScriptVersion
# <Script execution goes here>
#Log-Finish -LogPath $sLogPath -LogName $sLogName

try{
	$reader = [io.file]::OpenText($filename)
	try{
		"Creating file number $filecount"
		$writer = [io.file]::CreateText( `
			"{0}{1}.{2}" -f ($outputPath,$filecount.ToString("000"),$ext))
		$writer
		$filecount++
		$linecount = 0
		
		while($reader.EndOfStream -ne $true){
			"Reading $linesPerFile"
			while(($linecount -lt $linesPerFile) -and ($reader.EndofStream -ne $true)){
				$writer.WriteLine($reader.ReadLine())
				$linecount++
			}
			
			if($reader.EndOfStream -ne $true){
				"Closing file"
				$writer.dispose()
				
				"Creating file number $filecount"
				$writer = [io.file]::CreateText("{0}{1}.{2}" `
								-f ($outputPath,$filecount.ToString("000"),$ext))
				$filecount++
				$linecount = 0 
			}
		}
	} finally {
		$writer.Dispose()
	}
} finally {
	$reader.dispose()
}

$sw.Stop()

write-host "Split completd in "$sw.Elapsed.TotalSeconds" seconds"