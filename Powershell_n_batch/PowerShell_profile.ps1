#Resolving Local paths
$Local_folders_n_paths=[enum]::GetNames([System.Environment+SpecialFolder]) `
						|Select @{n="Name";e={$_}}, `
						@{n="Path";e={[environment]::getfolderpath($_)}}
echo "Desktop Path"
echo $($Local_folders_n_paths|?{$_.Name -eq 'Desktop'}).Path


## To enable  local modules
$env:PSModulePath += ";"+[environment]::getfolderpath("MyDocuments")

#UI settings
$shell = $Host.UI.RawU
$shell.WindowTitle = "Dev"
$shell.ForegroundColor = "Green"

$loc='dev'
$envs=@{dev='Development';QA='Testing'}
$root="\\root"
$base_path=$(Join-Path -Path $root -ChildPath $($envs.$loc))

#Shortcuts

$npp="C:\Softwares\Notepad++.exe"

if(-not $(get-item alias:np -ErrorAction SilentlyContinue)) {
	new-item alias:np -value "C:\Windows\System32\notepad.exe"
}

## Path short cutes

function src {set-location $root\$($envs.$loc)\SrcFiles}

## Latest 20 files
function  latest {param([int]$count=20) ls|sort -property lastwritetime|select -last $count}

##Search
function search{
	param([parameter(Mandatory=$true,ValueFromPipelineByPorpertyName=$true)]
	[ValidateNotNullOrEmpty()] [Alias("Pattern")] [String]$SearchPattern)
	process{
		$(ls -recurse|sort -property lastwritetime) -match  $SearchPattern
	}
 	
}

## Prit file with line number
function gcc($file) {$i=1;gc "$file"|%{"{0,4}`t{1}" -f $i,$_;$i++}}


$Shell.WindowTitle=$($envs.$loc)

write-host 'Custom powershell profile in effect'