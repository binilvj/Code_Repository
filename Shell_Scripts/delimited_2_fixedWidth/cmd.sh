awk -F',' '{printf "%3s%30s%8s\n",$1,$2,$3}' input.csv > input.fix
