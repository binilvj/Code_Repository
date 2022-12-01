#requires -version 2
<#
.SYNOPSIS
	<Overview of the script>

.DESCRIPTION
	<Brief DESCRIPTION>

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