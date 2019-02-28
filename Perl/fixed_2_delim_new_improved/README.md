# Fixed width to Delimited file

This will demonstrate how a Fixed width file can be converted to CSV file
There will be 4 inputs
 1) The Fixed width file file
 2) A file called contract in CSV format.This is format specification for Fixed width file
 3) The column number where column length specification is available in contract
 4) The delimiter required in output file. This need to be enclosed in single quotes


## Assumptions
1) It is assumed that that the file contract in csv format can be easily created
1) The input file is assumed to be a perfect one in format
1) Contract and csv are assumed to be in perfect sync
1) Any error in date format or number format will be ignored by the program


## Invocation
_perl fixed_2_delim_new_improved.pl input_2.fix contract.txt 3 '~'_
Samples of inputs and outputs are available in this Git folder to make it easy to try it the first time

## Installation
perl is pre-requisite for executing this script.
Download the file [fixed_2_delim_new_improved.pl](https://github.com/binilvj/test_code_repo2/blob/master/Perl/fixed_2_delim_new_improved/fixed_2_delim_new_improved.pl).
The script is ready for execution

## Pending tasks
1) Need to add diagnostic info to log so that others can use it and take help from expert using the log when in trouble
2) can try to use a config file. This may guard for issues in input parameters, especially for delimiter character
3) Need to add number validation for columns lengths read from contract file. If invalid the program need to exit
4) Validation of the input file. The line length can be validated.
