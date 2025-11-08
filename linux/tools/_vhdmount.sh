#!/bin/bash

#
# Mount a .vhd file
# libguestfs-tools
#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

# verif
#sudo virt-filesystems -a ~/VirtualBoxVMs/002-win7/wRATON.vhd
#sudo virt-fsck -a /tmp/002w7

sudo guestmount --add ~/VirtualBoxVMs/002-win7/wRATON.vhd --ro /tmp/002w7 -m /dev/sda3

