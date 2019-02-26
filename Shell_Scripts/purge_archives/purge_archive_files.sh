#!/bin/ksh
###############################################################
#script to purge old archival files
###############################################################



process_start()
{
proc_time=`date`
echo "-------------------------------------------------------------------------------------------" | tee -a $purge_script_logdir/purge_archive_script.log
echo "$Interface_name"_purge_archives" process starts at: $proc_time " | tee -a $purge_script_logdir/purge_archive_script.log
echo "-------------------------------------------------------------------------------------------" | tee -a $purge_script_logdir/purge_archive_script.log
}

process_end()
{
proc_time=`date`
echo "-------------------------------------------------------------------------------------------" | tee -a $purge_script_logdir/purge_archive_script.log
echo "$Interface_name"_purge_archives" process completes at: $proc_time " | tee -a $purge_script_logdir/purge_archive_script.log
echo "-------------------------------------------------------------------------------------------" | tee -a $purge_script_logdir/purge_archive_script.log
}

#Interface_name=$1;


scripts_dir=`dirname $0`
#scripts_dir=/informat/infa_shared_V861/Scripts/EBP

. $scripts_dir/Config/paths.config


v_date=`date +%Y%m%d`
v_time=`date +%H%M%S`



#Step 0 : Archiving the Log file

if [ -f $purge_script_logdir/purge_archive_script.log ]; then
    mv  $purge_script_logdir/purge_archive_script.log  $purge_archive_script_logdir/purge_archive_script_$v_date"_"$v_time".log"

        ret_val=$?

    if [ $ret_val -ne 0 ]
    then
        echo "Step 0: Archival of Script Log File Failed." |  tee -a $purge_script_logdir/purge_archive_script.log

        exit 1

    else

        echo "***********************Log file for purge_archive_script***********************" | tee -a $purge_script_logdir/purge_archive_script.log
        echo "Step 0: Archival of Script Log File Successful." | tee -a  $purge_script_logdir/purge_archive_script.log
    fi
else
echo "***********************Log file for purge_archive_script***********************" | tee -a $purge_script_logdir/purge_archive_script.log
fi

interface_count=`cat $scripts_dir/Config/Purge_Script_Interface_Names |wc -l`
interface_count_orig=`awk 'END{print NR}' $scripts_dir/Config/Purge_Script_Interface_Names`

if [ -s  $scripts_dir/Config/Purge_Script_Interface_Names ]; then

 echo "Proceed."
else
 echo "Step 1: Removal of Archive Files Failed. No data in Purge_Script_Interface_Names file." | tee -a  $purge_script_logdir/purge_archive_script.log
exit 1
fi


cat $scripts_dir/Config/Purge_Script_Interface_Names | while read LINE
do

Interface_name=$LINE;

. $scripts_dir/Config/paths.config
. $scripts_dir/Config/Purge_Script.config

process_start



#Step 1: Purge source archival files

if [ $no_src_days -lt 0 ]; then

 echo "Step 1: Removal of Source Archive Files Failed. No. of days '$no_src_days' for purging is lesss than 0." | tee -a  $purge_script_logdir/purge_archive_script.log
 exit 1
fi

file_count=`find $source_archivedir -type f -mtime +$no_src_days -exec echo {} \; | wc -l`

find $source_archivedir -type f -mtime +$no_src_days -exec echo {} \;
find $source_archivedir -type f -mtime +$no_src_days -exec rm -f {} \;  >> $purge_script_logdir/purge_archive_script.log
ret_val=$?
    if [ $ret_val -ne 0 ]; then
              echo "Step 1: Removal of Source Archive Files Failed." | tee -a  $purge_script_logdir/purge_archive_script.log

        exit 1
    else

      if [ $file_count -gt 0 ]; then

                echo "Step 1: $file_count Source archive files older than $no_src_days days removed successfully." | tee -a $purge_script_logdir/purge_archive_script.log
      else
              echo "Step 1: Source archive files older than $no_src_days days is not available. " | tee -a $purge_script_logdir/purge_archive_script.log

     fi

   fi



#Step 2: Purge scriptlog archival files

if [ $no_script_days -lt 0 ]; then

 echo "Step 2: Removal of Script Archive Files Failed. No. of days '$no_script_days' for purging is lesss than 0." | tee -a  $purge_script_logdir/purge_archive_script.log
 exit 1
fi

file_count=`find $archive_script_logdir -type f -mtime +$no_script_days -exec echo {} \; | wc -l`

find $archive_script_logdir -type f -mtime +$no_script_days -exec echo {} \;
find $archive_script_logdir -type f -mtime +$no_script_days -exec rm -f {} \;  >> $purge_script_logdir/purge_archive_script.log
ret_val=$?
    if [ $ret_val -ne 0 ]; then
              echo "Step 2: Removal of Script Archive Files Failed." | tee -a  $purge_script_logdir/purge_archive_script.log

        exit 1
    else

      if [ $file_count -gt 0 ]; then

                echo "Step 2: $file_count Script archive files older than $no_script_days days removed successfully." | tee -a $purge_script_logdir/purge_archive_script.log
      else
              echo "Step 2: Script archive files older than $no_script_days days is not available. " | tee -a $purge_script_logdir/purge_archive_script.log

     fi

   fi


#Step 3: Purge target archival files

if [ $no_tgt_days -lt 0 ]; then

 echo "Step 3: Removal of Target Archive Files Failed. No. of days '$no_tgt_days' for purging is lesss than 0." | tee -a  $purge_script_logdir/purge_archive_script.log
 exit 1
fi

file_count=`find $targetarchivedir -type f -mtime +$no_tgt_days -exec echo {} \; | wc -l`

find $targetarchivedir -type f -mtime +$no_tgt_days -exec echo {} \;
find $targetarchivedir -type f -mtime +$no_tgt_days -exec rm -f {} \;  >> $purge_script_logdir/purge_archive_script.log
ret_val=$?
    if [ $ret_val -ne 0 ]; then
              echo "Step 3: Removal of Target Archive Files Failed." | tee -a  $purge_script_logdir/purge_archive_script.log

        exit 1
    else

      if [ $file_count -gt 0 ]; then

                echo "Step 3: $file_count Target archive files older than $no_tgt_days days removed successfully." | tee -a $purge_script_logdir/purge_archive_script.log
      else
              echo "Step 3: Target archive files older than $no_tgt_days days is not available. " | tee -a $purge_script_logdir/purge_archive_script.log

     fi

   fi

#Step 4: Purge CEF archival files

if [ $no_cef_days -lt 0 ]; then

 echo "Step 4: Removal of CEF Archive Files Failed. No. of days '$no_cef_days' for purging is lesss than 0." | tee -a  $purge_script_logdir/purge_archive_script.log
 exit 1
fi

file_count=`find $archive_cef_log -type f -mtime +$no_cef_days -exec echo {} \; | wc -l`

find $archive_cef_log -type f -mtime +$no_cef_days -exec echo {} \;
find $archive_cef_log -type f -mtime +$no_cef_days -exec rm -f {} \;  >> $purge_script_logdir/purge_archive_script.log
ret_val=$?
    if [ $ret_val -ne 0 ]; then
              echo "Step 4: Removal of CEF Archive Files Failed." | tee -a  $purge_script_logdir/purge_archive_script.log

        exit 1
    else

      if [ $file_count -gt 0 ]; then

                echo "Step 4: $file_count CEF archive files older than $no_cef_days days removed successfully." | tee -a $purge_script_logdir/purge_archive_script.log
      else
              echo "Step 4: CEF archive files older than $no_cef_days days is not available. " | tee -a $purge_script_logdir/purge_archive_script.log

     fi

   fi


#Step 5: Purge audit archival files

if [ $no_audit_days -lt 0 ]; then

 echo "Step 5: Removal of Audit Archive Files Failed. No. of days '$no_audit_days' for purging is lesss than 0." | tee -a  $purge_script_logdir/purge_archive_script.log
 exit 1
fi
file_count=`find $archive_audit_log -type f -mtime +$no_audit_days -exec echo {} \; | wc -l`

find $archive_audit_log -type f -mtime +$no_audit_days -exec echo {} \;
find $archive_audit_log -type f -mtime +$no_audit_days -exec rm -f {} \;  >> $purge_script_logdir/purge_archive_script.log
ret_val=$?
    if [ $ret_val -ne 0 ]; then
              echo "Step 5: Removal of Audit Archive Files Failed." | tee -a  $purge_script_logdir/purge_archive_script.log

        exit 1
    else

      if [ $file_count -gt 0 ]; then

                echo "Step 5: $file_count Audit archive files older than $no_audit_days days removed successfully." | tee -a $purge_script_logdir/purge_archive_script.log
      else
              echo "Step 5: Audit archive files older than $no_audit_days days is not available. " | tee -a $purge_script_logdir/purge_archive_script.log

     fi

   fi




#Step 6: Purge reject archival files

if [ $no_reject_days -lt 0 ]; then

 echo "Step 6: Removal of Audit Archive Files Failed. No. of days '$no_reject_days' for purging is lesss than 0." | tee -a  $purge_script_logdir/purge_archive_script.log
 exit 1
fi

file_count=`find $reject_archivedir -type f -mtime +$no_reject_days -exec echo {} \; | wc -l`

find $reject_archivedir -type f -mtime +$no_reject_days -exec echo {} \;
find $reject_archivedir -type f -mtime +$no_reject_days -exec rm -f {} \;  >> $purge_script_logdir/purge_archive_script.log
ret_val=$?
    if [ $ret_val -ne 0 ]; then
              echo "Step 6: Removal of Reject Archive Files Failed." | tee -a  $purge_script_logdir/purge_archive_script.log

        exit 1
    else

      if [ $file_count -gt 0 ]; then

                echo "Step 6: $file_count Reject archive files older than $no_reject_days days removed successfully." | tee -a $purge_script_logdir/purge_archive_script.log
      else
              echo "Step 6: Reject archive files older than $no_reject_days days is not available. " | tee -a $purge_script_logdir/purge_archive_script.log

     fi

   fi


#------------------------------------------------------------------------------------------#

process_end

done


if [ $interface_count -ne $interface_count_orig ]; then

 echo "Step 7: No. of interfaces processed in script '$interface_count' is not equal to the no. of interfaces in Purge_Script_Interface_Names file '$interface_count_orig'." | tee -a  $purge_script_logdir/purge_archive_script.log
 exit 1
fi

run_time=`date`

echo "-------------------------------------------------------------------------------------------" | tee -a $purge_script_logdir/purge_archive_script.log
echo "purge_archive_script run completes at: " $run_time |  tee -a $purge_script_logdir/purge_archive_script.log
echo "-------------------------------------------------------------------------------------------" | tee -a $purge_script_logdir/purge_archive_script.log
