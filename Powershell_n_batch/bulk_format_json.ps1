#requires -version 2
<#
.SYNOPSIS
	A script to write formated JSON files from a input containing JSON strings
	and file name in the format - "file_name|JSONString"

.DESCRIPTION
	This script can format and write JSON strings into a file.
	A formatting function is created for this.


.PARAMETER listFile
	This is a list file containing targeted file name and JSON string separated by |

.PARAMETER outputPath
	Path where formated file will be written to

.PARAMETER Delimiter
	A delimited not used in the JSON string

.INPUTS
	None

.OUTPUTS
	Files containing formated JSON

.NOTES
	Version: 		0.5
	Author:			Binil
	Creation Date:	2017-Sep-28
	Purpose/Change:	Initial development

.EXAMPLE
	. bulk_format_json.ps1 -listFile \\path\input.csv -outputPath \\path -Delimiter '|'
	& bulk_format_json.ps1 -listFile \\path\input.csv -outputPath \\path -Delimiter '|'
#>

#---------------------------------------[Initialisation]------------------------------------

[CmdletBinding()]
	param(
	[Parameter(Position=0, Mandatory=$true)] [string]$listFile,
	[Parameter(Position=1, Mandatory=$true)] [string]$outputPath,
	[Parameter(Position=2, Mandatory=$true)] [string]$Delimiter

	)
#Set error action
#$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
#. "C:\Scripts\Functions\Logging_Functions.ps1"

#---------------------------------------[Declarations]---------------------------------------

#Script Version
$sScriptVersion = "1.0"

#Resolving Local paths
$Local_folders_n_paths=[enum]::GetNames([System.Environment+SpecialFolder]) `
						|Select @{n="Name"; e={$_}}, `
						@{n="Path"; e={[environment]::getfolderpath($_)}}
echo "Desktop Path"
echo $($Local_folders_n_paths|?{$_.Name -eq 'Desktop'}).Path

#Log File info
$sLogPath = [environment]::getfolderpath("MyDocuments")
$sLogName = "$((get-date).toString('yyyy-MM-dd-HH-mm-'))Bulk_JSON_Formatter.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName

#--------------------------------------[Function]---------------------------------------------

Function LogWrite{
	Param(
	[Parameter(Position=0, Mandatory=$true)] [string]$logString,
	[Parameter(Position=1, Mandatory=$false)]
	[ValidateSet('info','warning','error')][string]$severity="info"
	 )

	add-content $sLogFile -value $("{0,-30}{1,-10}{2}" `
		-f $((get-date).toString('yyyy-MM-ddTHH:mm:ss.ms')),$severity,$logString)
	if ($severity -eq "warning") {write-warning $logString}
	if ($severity -eq "error") {write-error $logString}

}


Function Format-JSON ($JSON, $indent=2,$outputFile,$errRef)
{

	Try{
			$StringWriter	= new-object System.IO.StreamWriter($outputFile)
			$JSONWriter	 	= new-object System.Text.Json.Utf8JsonWriter($StringWriter)
			#$JSONWriter.Formatting = "indented"
			$JSONWriter.Indented  = $(if($indent) {$true} else {$false})
			$JSON.WriteContentTo($JSONWriter)
			$JSONWriter.Flush()
			$StringWriter.Flush()
			Write-output $StringWriter.ToString()
			$StringWriter.Close()
		}

		Catch{
			$logString="Error occured in formatting - reference: Line read - $errRef.
						Outputfile: $outputFile.
						ErrorMessage: $error"
			LogWrite $logString "error"
		}
		Finally {
			$StringWriter.Close()
			$ErrorActionPreference="STOP"
		}


}
#>


#------------------------------------[Execution]--------------------------------------------

#Clear error flag from any previous command/script execution
$error.clear()
LogWrite "Starting Script"
LogWrite "Script was started as: $((Get-PSCallStack).position.text)"

#---------------------------------- Tests --------------------------------------------------
if($args.count -gt 3)
{LogWrite "Any parameters specified other than $listFile and $outputPath will be ignored" "warninig"}
if(($(ls $listFile|measure-object).count) -eq 0)
	{$logString="List File sprecified - $listFile - was not found. Script will exit"
	 LogWrite $logString "error"
	 throw $logString
	 }
if(($(cat $listFile|measure-object).count) -eq 0)
	{$logString="List File sprecified - $listFile - is empty. Script will exit"
	 LogWrite $logString "error"
	 throw $logString
	 }


if(!(test-path $outputPath))
	{$logString="Output path sprecified - $outptPath - was not found. Script will exit"
	 LogWrite $logString "error"
	 throw $logString
	 }

#-------------------------------- Formatting ----------------------------------------------
$count=0
import-csv $listFile -delimiter $delimiter -Header fileName,JSONString|foreach{
	$error.clear()
	$count++
	echo $_.JSONString
	#$JSON=[JSON]$_.JSONString
	$JSON=$_.JSONString
	$outputFile=$(join-path -path $outputPath -childPath $($_.fileName+'.json'))
	Format-JSON -JSON $JSON -indent 4 -outputFile $outputFile $count
}

echo "Script completed"
logWrite "Script completed"