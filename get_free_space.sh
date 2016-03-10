#!/bin/bash

### run the get_free_space_per_cell.sh script on all storage servers and print a grand total

### this script is intented to be executed from a server which has (passwordless) ssh access to all storage servers
### and requires that the get_free_space_per_cell.sh is in the same directory as this script


dcli -g cell_group -l root -x get_free_space_per_cell.sh | awk \
'
BEGIN {
  gd_total_size=0
}
{ gd_total_size+=$2
}
END {
  printf "%5.0f MB\n", gd_total_size
}
'
