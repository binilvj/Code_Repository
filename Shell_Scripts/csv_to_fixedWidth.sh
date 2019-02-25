#!/bin/bash
#####################################################################
## This program is a demonstration
######### ############ ########### ########
##This will demonstrate how a csv file can be converted to Fixed width file
##There will be 2 inputs 
## 1) The csv file 
## 2) A file called contract 
##    It will have the description of the fixed width file in csv format
#####################################################################
### Assumptions########
## a) It is assumed that the file contract in csv format can be easily created
## b) The CSV file is assumed to be a perfect one in format
## c) contract and csv are assumed to be in perfect sync
## d) any error in date format or number format will be ignored by the program 
####################################################################
####################################################################
###### To-Do list ##################################################
## 1) There should be following validations on the contract csv and the program should exit on failure
##    a)for completeness and 
##    b)for compatibility to the program
## 2) There should be validation on Fixed width input
##    a) for completeness
##    b) Decision should be taken on the records that fail in validation
##################################################################
## Variables ###
## Read appropriate Config###
script_dir=`dirname $0`
log_nm=`basename $0`_`date '+%Y%m%d_%H%M%S'`.log
## Argument validation##
if [ $# -ne 2 ]; then
    echo "Expected invocation is fixed_2_delim.sh input_file_name Contract_file_name.. Exiting " |tee -a log_nm
    exit
else
    input_file=$1
    cntrct_file=$2
    echo "inputs recieved:$input_file $cntrct_file"|tee -a log_nm
fi
## Picks string before first . and add a fix at end
## Eg: file.txt become file.fix
output_nm=`echo $1|cut -d . -f1 `.fix
echo "output will be written into $output_nm"|tee -a log_nm
## Generic code to create the awk commad that will create the fixed width file ## Starts

## Creates printf format string
## Assumes that 
##    all fields are strings.. Only space padding is supported now
##    Third field in Contract file is length of field 
##    First column will be in row 1 of contract and rest in other rows
## Expected output is printf "%xs%ys%zs 
##    where x,y and z are lengths of three fields
awk_print_format='printf "'`awk -F, '{printf ("%%%ss",$3)}' $cntrct_file`

## Creates printf variables for Awk command
##     if n columns are there n number of variables are needed
##Currently last line can't have newline
#count=`wc -l $cntrct_file|cut -d' ' -f1`
count=`awk 'END{print NR}' $cntrct_file`
awk_print_vars='"'$(echo $(for ((counter=1;counter<=$count; counter++));  do printf ",$%s" $counter; done;))
## Expected output is ",$1,$2,$3 .........
### rev is reverse string command in bash. For ksh following may work
#echo $awk_print_vars | awk -v FS="" '{ for(N=NF; N>=1; N--) printf("%s", $N); }'

## Final combined awk command
## Assumes that , is fiedl separator in Inputfile
awk_command=$(echo "awk  -F, '{"$awk_print_format"\n"$awk_print_vars}"' $input_file > $output_nm")
echo $awk_command
awk_command1="'{"$awk_print_format"\n"$awk_print_vars}"' $input_file > $output_nm"
awk_command2="awk  -F, '{"

## Generic code to create the awk command that will create the fixed width file ## Ends

## Executes teh awk command
echo $awk_command> cmd.sh
## If the the conversion is needed repeatedly, the command can be saved from cmd.sh file and can be reused
bash cmd.sh

