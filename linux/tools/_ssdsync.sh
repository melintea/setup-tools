#!/bin/bash

#
# Sync /home across drives
#

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit 1
fi

mkdir /tmp/sda5
mount -t auto /dev/sda5 /tmp/sda5
if [ ! -d "/tmp/sda5/home" ]; then
  echo "/tmp/sda5/home does not exist."
  exit 1
fi

rsync -avzuxHAX /home/ /tmp/sda5/home/

