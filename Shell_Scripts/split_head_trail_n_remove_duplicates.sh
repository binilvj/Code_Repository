#!/bin/ksh
#####################################################################################
# Shell script to split the input source file into header, detail and trailer files.
# HEADER_ID,DETAIL_ID,TRAILER_ID need to be passed as arguments
#####################################################################################
# Added 3 parameters  for checking presence of duplicate agreement IDs
# Inputs are following
# 1) file_type - D for delimited and F for Fixed width files
# 2) Parameter1 - For D it will be the delimiter the character should be enclosed in single quotes like '|'
#                 For Fixed width this will be the starting position of teh Agrrement number column
# 3) Parameter2 - For Delimited (D) this will be the position of agreement column from left
#                 For Fixed width (F) this will be teh length of Agreement number column
##########################################################################################

Interface=$1;           # interface name
source_file_name=$2;    # source file name along with directory
target_file_dir=$3;     # target file directory
structure=$4;           # If both header and trailer are there, pass the argument as HT. If only trailer is there, pass as T. If only Header, pass as H.


######## to remove existing Interface_Record_ID_Count file############

if [ -e $target_file_dir/$Interface"_Record_ID_Count" ]
then
rm $target_file_dir/$Interface"_Record_ID_Count"
fi

###### to assign header id, detail id and trailer id based on the arguments#########

if [ $4 = HT -a $# -eq 10 ]
then
HEADER_ID=$5;
DETAIL_ID=$6;
TRAILER_ID=$7;
#### Additional Input parameters for duplicate policy number check ##########
file_type=$8
param1=$9
param2=${10}

elif [ $4 = H -a $# -eq 9 ]
then
HEADER_ID=$5;
DETAIL_ID=$6;
#### Additional Input parameters for duplicate policy number check ##########
file_type=$7
param1=$8
param2=$9
elif [ $4 = T -a $# -eq 9 ]
then
DETAIL_ID=$5;
TRAILER_ID=$6;
#### Additional Input parameters for duplicate policy number check ##########
file_type=$7
param1=$8
param2=$9

else
echo "Invalid no. of arguments passed or Invalid argument for structure of file(HT,H or T). "
exit 1
fi


########### to create header file###########################

if [ $4 = HT -o $4 = H ]
then
 var_header_line=`grep -c ^$HEADER_ID $source_file_name`
 echo $var_header_line
 echo $HEADER_ID"|"$var_header_line >>$target_file_dir/$Interface"_Record_ID_Count"
 if [ $var_header_line -gt 0 ]
 then
  grep ^$HEADER_ID $source_file_name > $target_file_dir/$Interface"_Header_file"
 else
  > $target_file_dir/$Interface"_Header_file"
 fi

fi

############ to create trailer file##########################

if [ $4 = HT -o $4 = T ]
then
 var_trailer_line=`grep -c ^$TRAILER_ID $source_file_name`
 echo $var_trailer_line
 echo $TRAILER_ID"|"$var_trailer_line >>$target_file_dir/$Interface"_Record_ID_Count"
 if [ $var_trailer_line -gt 0 ]
 then
  grep ^$TRAILER_ID $source_file_name > $target_file_dir/$Interface"Trailer_file"
 else
  > $target_file_dir/$Interface"Trailer_file"
 fi

fi

############# to create detail file###########################

case $structure in
HT)
  var_detail_line=`grep -v -e ^$HEADER_ID -e ^$TRAILER_ID $source_file_name |wc -l`
  echo $var_detail_line
  echo $DETAIL_ID"|"$var_detail_line >>$target_file_dir/$Interface"_Record_ID_Count"
  if [ $var_detail_line -gt 0 ]
  then
   grep -v -e ^$HEADER_ID -e ^$TRAILER_ID $source_file_name > $target_file_dir/$Interface"Detail_file"
  else
   > $target_file_dir/$Interface"Detail_file"
  fi
;;

T)
 var_detail_line=`grep -v ^$TRAILER_ID $source_file_name |wc -l`
 echo $var_detail_line
 echo $DETAIL_ID"|"$var_detail_line >>$target_file_dir/$Interface"_Record_ID_Count"
 if [ $var_detail_line -gt 0 ]
 then
  grep -v ^$TRAILER_ID $source_file_name > $target_file_dir/$Interface"Detail_file"
 else
  > $target_file_dir/$Interface"Detail_file"
 fi
;;

H)
 var_detail_line=`grep -v ^$HEADER_ID $source_file_name |wc -l`
 echo $var_detail_line
 echo $DETAIL_ID"|"$var_detail_line >>$target_file_dir/$Interface"_Record_ID_Count"
 if [ $var_detail_line -gt 0 ]
 then
  grep -v ^$HEADER_ID $source_file_name > $target_file_dir/$Interface"Detail_file"
 else
  > $target_file_dir/$Interface"Detail_file"
 fi
;;

*)
 echo " Invalid argument for structure of file"
esac

### This section looks for duplicate entries  for an agreement number ##

case $file_type in
F)
                awk -v start=`echo $param1` -v len=`echo $param2` '{agmt=substr($0,start,len);count[agmt]++;} END {OFS="|";for (j in count) {if(count[j]>1) pr
int j,count[j]}}' $target_file_dir/$Interface"Detail_file" >$target_file_dir/$Interface"_duplicates"
        ;;
D)
                awk -v col_num=`echo $param2` -F"$param1" '{agmt=$col_num;count[agmt]++;} END {OFS="|";for (j in count) print j,count[j]}' $target_file_dir/$I
nterface"Detail_file" >$target_file_dir/$Interface"_duplicates"
        ;;
*)
                echo "Unknown file type. It should be either Fixed width(F) or Delimited(D)"
                exit 1
esac

