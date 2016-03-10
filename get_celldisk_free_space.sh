#!/bin/bash

### list the free space on the current exadata storage server
### it will get the smallest free space between all celldisks and multiplies this with the number of available (online) disks
### this because all griddisks in an asm diskgroup (with normal or high redundancy) needs to be the same size and we are always using all 12 celldisks when creating griddisks

### this script is intented to be executed on the storage server itself
### when using the get_free_space.sh script, it will copy this script to all storage servers and execute it

cellcli -e "list celldisk attributes freespace where disktype='HardDisk' and status='normal'" | awk \
'
BEGIN { 
  gd_count=0
} { 
  gd_unit=substr($1, length($1), 1)
  if (gd_unit == "T") { 
    gd_size_mb=$1*1024*1024
  }
  else if (gd_unit == "G") {
    gd_size_mb=$1*1024
  }
  else if (gd_unit == "M") {
    gd_size_mb=$1
  }
  else {
    print "unit size " gd_unit " not recognized"
    exit 1
  }
  if (gd_min_size>=gd_size_mb || gd_min_size == "") { 
    gd_min_size=gd_size_mb
  }
  gd_count++
} 
END { 
  printf "%5.0f\n", gd_min_size * gd_count
}
'
