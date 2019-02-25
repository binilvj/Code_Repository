#!/bin/perl
## This program is a demonstration
######### ############ ########### ########
##This will demonstrate how a Fixed width file can be converted to CSV file
##There will be 4 inputs 
## 1) The Fixed width file file 
## 2) A file called contract in CSV format.This is format specification for Fixed width file
## 3) The column number where column length specification is available in contract
## 4) The delimiter required in output file. This need to be enclosed in single quotes
##    
#####################################################################
### Assumptions########
## a) It is assumed that that the file contract in csv format can be easily created
## b) The input file is assumed to be a perfect one in format
## c) contract and csv are assumed to be in perfect sync
## d) any error in date format or number format will be ignored by the program 
####################################################################
####################################################################

#Following is how to call the script
#fixed_2_delim_new_improved.pl input_2.fix contract.txt 3 '~'

### Pending tasks
#	1) Need to add diagnostic info to log so that others can use it and take help from expert using the log when in trouble
#	2) can try to use a config file. This may gaurd for issues in input parameters, especially for delimiter character
#	3) Need to add number validation for columns lengths read from contract file. If invalid the program need to exit
#	4) Validation of the input file. The line length can be validated. 

#####################################################################


my @columns; # this will hold the column of a row
my @contract; # split contract
my $input_file; # input file
my $cntrct_file; # contract file
my $line;	# A temporary holder for lines read in loop
#my $i; #loop counter
my $format; #The fixed width file format to be used in unpack function
my $col; 	#A temporary hold variable for the fxed width file column values
my $delim;
my $length_pos;
my $pattern1; ## this variable will be used create serach patterns
my $pattern2; ## this variable will be used create serach patterns
my $output='delimited_file.txt'; ## Output file name

die "expected invocation is ".$0." input.fix contract.txt position_of_colum_length output_file_delimiter " unless($#ARGV==3);

#Opening files
# input files are read in readonly mode and output file in write mode. The program exits on failure
$input_file=shift ;
open (FIXED,'<'.$input_file)||die("Exiting as the program could not open the input file $input_file:$! \n");

# Contract files are read in readonly mode and output file in write mode. The program exits on failure
$cntrct_file=shift ;
open (CONTRACT,'<'.$cntrct_file)||die("Exiting as the program could not open the input file $cntrct_file:$! \n");
open (OUTPUT,'>'.$output)||die("Exiting as the program could not create the output file $output:$! \n");

# Reading from input the column number for the length in the contract.
# For example If 3rd column has lengths of the columns then value will be 3
$length_pos=shift;

# Ouput delimiter. This will be the delimiter used in the output file
$delim=shift;

# create the format string from Contract
# This is essentially adding A to the length of the field
# Eg: if field lengths are 10,20,30 the resulting string will be A10A20A30
print "Reading the Contract\n";
foreach (<CONTRACT>)
        {
        $line=$_;
        # to skip empty lines
	next if($line=~/^$/);
        # stores the file content in an array
	@contract=split(/\,/,$line);
        
	$format=$format.'A'.$contract[$length_pos-1];
        }
# Diagnostic print. This will be the format string used in unpack function
print "The fixedwidth File format".$format."\n";
	
	#Creates pattern variabes to remove leading and Trailing spaces after converting to CSV
	#pattern1: Traiiing space match. It looks for Non-Space and non-Delimiter caharacter followed by Spaces and Delimiter
	# If delimiter is ~ it matches for "ABC  ~" kind of strings
    $pattern1='([^\s\\'.$delim.']+)(\s+)(\\'.$delim.')';
	print "Pattern1:".$pattern1."\n";
	#pattern2: Leading space match. It looks for Delimiter followed by Space then a Non Space and non Delimiter caharacters
	# If delimiter is ~ it matches for "~   ABC" kind of strings
	$pattern2='(\\'.$delim.')(\s+)([^\s\\'.$delim.']+)';
	print "Pattern2:".$pattern2."\n";
	#pattern3: Null column match. It looks for Delimiter followed by Spaces alone then  Delimiter caharacter
	# If delimiter is ~ it matches for "~   ~" kind of strings
	$pattern3='(\\'.$delim.')(\s+)(\\'.$delim.')';
	print "Pattern3:".$pattern3."\n";

print "Reading the fixed width input file\n";
# Reads the fixed width input file and writes a delimited output
foreach (<FIXED>)
        {
        $line=$_;
	# Skip the loop for an empty line
        next if($line=~/^$/);

	#Splitting up happen here. @columns is an array variable each of $columns[0] to $columns[n] contain data from each columns
        @columns=unpack("$format",$line);
        
	#Here the column separator is added		
        $col=join($delim,@columns);

	# Any trailing and leading spaces are removed here. Any spaces within the string will not be affected though.
	# this is done in two steps
	# Step1: Trailing spaces are replaced
	$col=~s/$pattern1/$1$3/g;
	# Step2: Leading spaces are replaced
	$col=~s/$pattern2/$1$3/g;
	# Step3: Spaces in Null columns are cleared
	$col=~s/$pattern3/$1$3/g;
        printf OUTPUT "$col\n";

        }
print "The program completed. The delimited data will be available in file  $output in the current directory\n";
