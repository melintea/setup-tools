#!/bin/bash

#
# Sync /home across drives
#

RED='\033[1;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

function print()
{
    color=$1
    text=$2
    printf "${color}${text}${NC}\n"
}


# ------------------------------------------------------------------------

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

dmres=`/usr/sbin/dmraid -s -s`
retval=$?
if [[ $? != 0 || ! $dmres =~ "status : ok" ]]; then
  print "${RED}" "FAIL WITH: ${retval}\n${dmres}\n"
  exit 1
fi
echo "Last successful run:"
ls -l "$0"


mkdir /tmp/sda5
mount -t auto /dev/sda5 /tmp/sda5
if [ ! -d "/tmp/sda5/home" ]; then
  echo "/tmp/sda5/home does not exist."
  exit 1
fi

rsync -avzuxHAX /home/ /tmp/sda5/home/

umount /tmp/sda5

# timestamp last good run
if [ -f "$0" ]; then
  touch "$0"
fi
