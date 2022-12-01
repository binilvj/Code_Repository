#requires -version 2
<#
.SYNOPSIS
	Ouput directory stats

.DESCRIPTION
	Ouput directory stats (Number of files and file size totals) for one or more directories 

.PARAMETER Path
	Specifies the SringValue to one or more files. Wild cards are permitted. Default to Current directory
	
.PARAMETER LiteralPath
	Exact value is used for Directory.
	If escape characters are included surround it by single quotes

.PARAMETER Only
	No Sub diretory stats

.PARAMETER Every
	All Sub diretory stats

.PARAMETER FormatNumbers
	Format numbers in output to include 1000 separators

.PARAMETER Total
	Ouputs tital of numbers

.INPUTS
	None

.OUTPUTS
	None

.NOTES
	Version: 		1.0
	Author:			Binil
	Creation Date:	2018
	Purpose/Change:	developed based on Get-DirStats.ps1 by Bil Stewart (bstewart@iname.com)

.EXAMPLE
	.\Get-DirStats.ps1 
	outputs the MD5 has string
	
.EXAMPLE
	.\Get-DirStats.ps1  -HashType  SHA1
	outputs the SHA1 has string
#>

#---------------------------------------[Initialisation]------------------------------------

#Set error action
#$ErrorActionPreference = "SilentlyContinue"

#Dot Source required Function Libraries
#. "C:\Scripts\Functions\Logging_Functions.ps1"

[CmdletBinding(DefaultParameterSetName="Path")]
param(
	[Parameter(ParameterSetName="Path",Position=0,Mandatory=$False,ValueFromPipeline=$true)]
		$Path=(get-location).Path,
	[Parameter(ParameterSetName="LiteralPath",Position=0,Mandatory=$True)]
		[String[]] $LiteralPath,
	[Switch] $Only,
	[Switch] $Every,
	[Switch] $FormatNumbers,
	[Switch] $Total
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


$ParameterSetName=$PSCMDLET.ParameterSetName
if($ParameterSetName -eq "Path")  {
	$PIPELINEINPUT = (-not $PSBOUNDPARAMETERS.ContainsKey("Path")) -and (-not $Path)
	echo "input:"$Path
} elseif (ParameterSetName -eq "LiteralPath") {
	$PipelineInput = $false
}

[UInt64] $script:totalCount=0
[UInt64] $script:totalbytes=0



function get-directory($item){
	#Returns a [System.IO.DirectoryInfo] object if it exists
	
	if($ParameterSetName -eq "Path")  {
		if (Test-path -path $item -Pathtype container){
			$item=get-item -path $item -Force
		}
	}
	elseif(ParameterSetName -eq "LiteralPath") {
		if (Test-path -LteralPath $item -Pathtype container){
			$item=get-item -Literalpath $item -Force
		}
	}
	if ($item -and ($item -is [System.IO.DirectoryInfo])) {
		return $item
	}
}

function Format-Object {
	process{
		$_|select-object Path,
		@{Name="Files"; Expression={"{0:N0}" -f $_.Files}},
		@{Name="Size"; Expression={"{0:N0}" -f $_.Size}}
	}
}

function Get-DirectoryStats ($directory, $recurse, $format) {
	<#Outputs directory stats for specified directory. With -recurse
	  the function includes files in all the subdirectories of specified
	  directory. With -format, numbers in the output objects are
	  formatted with the Format-output filter
	#>
	
	Write-Progress -Activity "Get-DirStats.ps1" -Status "Reading '$($directory.FullName)'"
	$files = $directory | gci -Force -Recurse:$recurse|?{ -not $_.PSIsContainer}
	#$files
	#$files | Measure-object -sum -Property Length|Select-object @{Name="Files"; Expression={$_.Count}},@{Name="Size"; Expression={$_.Sum}}
	if ($files) {
		Write-Progress -Activity "Get-DirStats.ps1" -Status "Calculating '$($directory.FullName)'"
		$output = $files | Measure-object -sum -Property Length |Select-object `
					@{Name="Path"; Expression={$directory.FullName}},
					@{Name="Files"; Expression={$_.Count;$script:totalCount += $_.Count}},
					@{Name="Size"; Expression={$_.Sum;$script:totalbytes += $_.Sum}}
	} else {
		$output = "" | Measure-object -sum -Property Length |Select-object `
					@{Name="Path"; Expression={$directory.FullName}}, 
					@{Name="Files"; Expression={0}},
					@{Name="Size"; Expression={0}}
	}
	if ( -not $format ) {$output} else { $output | Format-object}
}

# Get the item to process, no matter whether the inpt comes from the pipeline or not

if ( $PipelineInput ) {
	$item = $_
} else {
	switch( $ParameterSetName ) {
		"Path" 	{ $item = $Path }
		"LiteralPath" { $item = $LiteralPath }
	}
}

#echo "item:"$item

$directory = Get-Directory -item $item 
if ( -not $directory ) {
	#Write an error if the item is not a directory 
	Write-Error -Message "Path '$item' is not a directory in the file system." -Category InvalidType
	return
}

#echo "directory:"$directory

#Directory stats for first level directory
Get-DirectoryStats -directory $directory -recurse:$false -format:$FormatNumbers
if ($only) { return }

# get subdirectory stats
$directory | Get-ChildItem -Force -Recurse:$Every|?{$_.PSIsContainer} `
	|%{Get-DirectoryStats -directory $_ -recurse:( -not $Every ) -format:$FormatNumbers}

if ($Total) {
	#IF -total is specified
	$output = "" | Select-object `
					@{Name="Path"; Expression={"<Total>"}},
					@{Name="Files"; Expression={$script:totalCount}}, 
					@{Name="Size"; Expression={$script:totalbytes}}
	
}

#if -FormatNumber option is specified
if ( $FormatNumbers ) {$output|Format-Object} else {$output}

