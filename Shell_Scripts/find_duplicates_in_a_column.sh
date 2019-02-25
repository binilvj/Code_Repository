#!/bin/ksh
#####################################################################################
# Shell script to  list duplicate values coming in a specific column in input file
# Output will be given in a file to be used in informatica mapping
#####################################################################################
# There are 6 inputs
# 1) Interface name
# 2) Source file name _ this is supposed to be a file with all records in same structure, with complete path
# 3) Target directory - The directory where the duplicate value file will be created
# 4) file_type - D for delimited and F for Fixed width files
# 5) Parameter1 - For D it will be the delimiter. The character should be enclosed in single quotes like '|'
#                 For Fixed width this will be the starting position of the column
# 6) Parameter2 - For Delimited (D) this will be the ordinal position of column from left
#                 For Fixed width (F) this will be the length of column
##########################################################################################

if [ $# -ne 6 ]
then
echo "Invalid no. of arguments passed "
echo "Expected invocation is $0 interface source_file_name target_file_dir file_type param1 param2"
exit 1
fi

Interface=$1;           # interface name
source_file_name=$2;    # source file name along with directory
target_file_dir=$3;     # target file directory

file_type=$4            # Whether the file is delimited(D) or Fixed width(F)
param1=$5               # This will be starting position for Fixed width file and will be the delimiter for delimited file
param2=$6               # This will be the Length of the field for fixed width file and will be the column number for delimited file



if [ ! -s $source_file_name ]
then
        echo "No file was found with data when checked with name $source_file_name.Script will exit." >2
        exit
fi

### This section looks for duplicate entries in the column #

case $file_type in
F)
                awk -v start=`echo $param1` -v len=`echo $param2` '{agmt=substr($0,start,len);gsub(/^[[:space:]]*|[[:space:]]*$/,"",agmt);count[agmt]++;} END
 {OFS="|";for (j in count) {if(count[j]>1) print j,count[j]}}' $source_file_name >$target_file_dir/$Interface"_duplicates_ext_ref"
        ;;
D)
                awk -v col_num=`echo $param2` -F"$param1" '{agmt=$col_num;gsub(/^[[:space:]]*|[[:space:]]*$/,"",agmt); count[agmt]++;} END {OFS="|";for (j in
 count) print j,count[j]}' $source_file_name >$target_file_dir/$Interface"_duplicates_ext_ref"
        ;;
*)
                echo "Unknown file type. It should be either Fixed width(F) or Delimited(D)"
                exit 1
esac
