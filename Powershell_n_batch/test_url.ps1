$path="E:\Binil\Cognizant Codes\output"
$logpath=Join-Path -Path $path -ChildPath "URL_test_log.txt"
$test_result=Join-Path -Path $path -ChildPath "URL_test_results.txt"
$url_list=Join-Path -Path "E:\Binil\Cognizant Codes\input" -ChildPath "URL_list.txt"

date|out-file -append -filepath $test_result
date|out-file -append -filepath $logpath

cat $url_list|foreach{
	$error.clear()
	echo "testing URL:$_"
	
	try{
		$url=$_
		echo $url|out-file -append -filepath $logpath
		$request = invoke-webrequest $url|out-file -append -filepath $logpath
		echo "$url -- Success"|out-file -append -filepath $test_result
	}
	catch [System.Net.WebException]{
		echo $url" -- "$error[0].exception|out-file -append -filepath $logpath
		echo "$url -- Failed"|out-file -append -filepath $test_result
	}
	finally
	{	
	echo "-------------------------------------"|out-file -append -filepath $logpath
	$ErrorActionPreference = "Continue" 
	}
}



