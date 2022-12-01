<#
Excel template formula

'=substitute(substitute(substitute($D$1,"Col1",$A1),"start",$B1),"end",$C1)'
Assumption
Column name in Col A
Column Start position in Col B
Column End position in Col C
and '@{name='Col1';expression={$_.Substring(start,end).Trim()}},' in D1 
#>

get-contect "\path\fixed_width_file.txt" `
|select -property `
@{name='Col1';expression={$_.Substring(0,6).Trim()}}, `
@{name='Col2';expression={$_.Substring(7,9).Trim()}}, `




@{name='Coln-1';expression={$_.Substring(15,18).Trim()}}, `
@{name='Coln';expression={$_.Substring(19,20).Trim()}} `
|export-csv "\path\file.csv"
