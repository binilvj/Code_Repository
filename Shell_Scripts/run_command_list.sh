# Script is designed to execute a set of commands  stored in a file line by line
# Not recommened for conditional executions, loops, or variable assignments 
# If any command fail the script will exit
# The script is designed to restart from the point of failure
# Installation Instructions
# --------------------------
# Replace /root/script_log with appropriate path before execution
# Keep the list of commands to be executed in file command_list.txt
# Log Files
# ---------
# A new log file will be created after each execution.
# Periodic purging of these might be needed
####################################################

set -x   #debug mode

################ Variable assignments ####################
# file that will hold line number of the command that was executed successfully
count_file=/root/script_log/count_file.txt;
# Log file will hold the output of the commands executed
log_file=/root/script_log/run_log`date +%Y%m%d%H%M%S`.txt;
#initialise counter
count=1  
# Read from the count file last step number
last_stop=`cat $count_file`  

## Loop to read the command file
while read Command 
do 
 if [ $last_stop -le $count ]; then  #To skip already succeeded commands in previous runs
  `$Command >> $log_file 2>&1`  # Execute and log the outputs and errors
### Error check ####
  ret_val=$?;  
	  if [ $ret_val -ne 0 ];  then  #error check
  		echo "Exiting...." |  tee -a $log_file;  
	  	exit $step_num ; 
	  fi
### Error check ####
 fi #first if closes

 echo $count > $count_file  ### Writ the line number of command executed without error
 count=`expr $count + 1`  # Increment counter
done </root/script_log/command_list.txt
## Loop ends

echo "0" > $count_file  ## After all commands are executed, set to zero to prevent from skipping commands in next execution
echo "Execution completed" >$log_file
