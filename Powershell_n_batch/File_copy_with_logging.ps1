$sSourcePath=\\sharepath\source_path
$sTargetPath=\\sharepath\target_path
$logPath=\\LogDir

cd $sSourcePath
ls |sort -property Length|foreach {
	$fileName=$_
	Copy $fileName $sTargetPath
	if($?)
		{echo $filename.FullName >>$logPath\File_copied.log}
	else
		{echo $filename.FullName >>$logPath\Failed_to_copy.log}
}
