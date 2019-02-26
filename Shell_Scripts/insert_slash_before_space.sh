#!/bin/csh -f
# This is a simple program to insert a slash before spaces in the file. This is useful when file or directory names have spaces and they has to be used in a script
sed '\
s/ /\\\\
/' file

