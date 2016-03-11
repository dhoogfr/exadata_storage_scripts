#!/bin/bash

### run the get_celldisk_free_space.sh script on all storage servers and print a grand total

### this script is intented to be executed from a server which has (passwordless) ssh access to all storage servers
### and requires that the get_celldisk_free_space.sh is in the same directory as this script


dcli -g cell_group -l root -x get_celldisk_free_space.sh | awk \
'
BEGIN {
  gd_total_size=0
  printf "\n"
  printf "%-12s %14s %6s %14s\n", "Server", "Free (MB)", "#Disks", "Cell Free (MB)"
  printf "%-12s %14s %6s %14s\n", "------", "---------", "------", "--------------"
}
{ gd_total_size+=$2
  printf "%-12s %14.0f %6.0f %14.0f\n", $1, $2, $3, $4
}
END {
  printf "\n"
  printf "\n"
  printf "Total Size: %5.0f MB\n", gd_total_size
  printf "\n"
}
'
