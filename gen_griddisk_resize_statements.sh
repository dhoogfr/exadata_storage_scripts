#!/bin/bash

### generate the cellcli command to resize all griddisks used for a given asm diskgroup to the new given size
### use dcli to run this script against all storage servers

### set the correct diskgroup name and newsize in the 2 variables below
### note that the diskgroup must be mounted on asm level before this will work

l_asmdg=DATA1
l_newsize=10G

if [ "$l_asmdg" == "" ] || [ "$l_newsize" == "" ]
then
  echo "usage: $0 <asm diskgroup name> <newsizeG|T>"
  exit -1
fi

l_resize_cmd=$(cellcli -e "list griddisk attributes name where asmDiskGroupName = ${l_asmdg}" | awk -v l_newsize=${l_newsize} 'BEGIN {grid_list="alter griddisk "; l_sep=""} {grid_list=(grid_list)(l_sep)($1); l_sep=","} END {print grid_list " size=" (l_newsize)}')

### cowardly opted to not directly execute the generated command but instead output it, mainly when resizing to a lower value
#cellcli -e "${l_resize_cmd}"
l_host=$(hostname --short)
echo "dcli -c ${l_host} -l root cellcli -e \"${l_resize_cmd}\""
