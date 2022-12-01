#requires -version 2
<#
.SYNOPSIS
	Outputs MD5 or SHA1 has for the input string

.DESCRIPTION
	Outputs MD5 or SHA1 has for the input string

.PARAMETER StringValue
	Specifies the SringValue to one or more files. Wild cards are permitted
	
.PARAMETER LiteralStringValue
	Similar to SringValue but no Wild cards are permitted. Exact value is used.
	If escape characters are included surround it by single quotes

.PARAMETER HashType
	MD5 or SHA1. Default value in MD5

.INPUTS
	System.String, System.IO.FileInfo

.OUTPUTS
	PSObjects containing the file Strings and hash values

.NOTES
	Version: 		1.0
	Author:			Binil
	Creation Date:	2018
	Purpose/Change:	developed based on Get-FileHash.ps1 by Bil Stewart (bstewart@iname.com)

.EXAMPLE
	.\Get-Hash.ps1 "Test"
	outputs the MD5 has string
	
.EXAMPLE
	.\Get-Hash.ps1 "Test"  -HashType  SHA1
	outputs the SHA1 has string
#>

#---------------------------------------[Initialisation]------------------------------------

#Set error action
#$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
#. "C:\Scripts\Functions\Logging_Functions.ps1"

[CmdletBinding(DefaultParameterSetName="StringValue")]
param(
	[Parameter(ParameterSetName="StringValue",Position=0,Mandatory=$TRUE)]
		[String[]] $StringValue,
	[Parameter(Position=1)] [String] $HashType="MD5"
)

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
$sLogName = "$((get-date).toString('yyyy-MM-dd-HH-mm-'))get-hash.log"
$sLogFile = Join-Path -Path $sLogPath -ChildPath $sLogName


switch ($HashType) {
	"MD5"{
		$Provider= new-object System.Security.Cryptography.MD5CryptoServiceProvider
		break
	}
	"SHA1"{
		$Provider= new-object System.Security.Cryptography.SHA1CryptoServiceProvider
		break
	}
	"default"{
		throw "HashType must be one of the following : MD5 SHA1"
	}
}
# If the StringValue is not bound , assume input comes from a pipeline
if($PSCMDLET.ParameterSetName -eq "StringValue") {
	$PIPELINEINPUT = -not $PSBOUNDPARAMETERS.ContainsKey("StringValue")
}

function get-hash($StringValue){
	#Returns an object containing StringValue and its hash  as a HEX string
	#The Provider object must have  a ComputeHash method that returns an array of bytes
	$bytes=[System.Text.Encoding]::ASCII.GetBytes($StringValue)
	$hash=$Provider.ComputeHash($bytes)
	$base64=[System.Convert]::ToBase64String($hash)
	echo "Output:"$base64
}


if($PSCMDLET.ParameterSetName -eq "StringValue")  {
	echo "input:"$StringValue
	get-hash $StringValue
}
