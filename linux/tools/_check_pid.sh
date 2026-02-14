#!/bin/bash

#
# Generate a report and a core for a process
# Usage: sudo _check_pid.sh PID
#


if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root"
  echo "Usage: sudo `basename $0` <pid>"
  exit 1
fi

if [ $# -ne 1 ]
then
  echo "Usage: sudo `basename $0` <pid>"
  ps -ef | grep inin
  ps -ef | grep media
  exit 1
else
  pid=$1
fi

echo "Checking ${pid}..."

gdb -batch \
      -ex "set logging file $pid.log" \
      -ex "set logging on" \
      -ex "set pagination off" \
      -ex "printf \"**\n** Process info for $pid \n** Generated `date`\n\"" \
      -ex "attach $pid" \
      -ex "printf \"*\n* bt info proc \n*\n\"" \
      -ex "bt" \
      -ex "info proc" \
      -ex "printf \"*\n* Libraries \n*\n\"" \
      -ex "info sharedlib" \
      -ex "printf \"*\n* Memory map \n*\n\"" \
      -ex "info target" \
      -ex "printf \"*\n* Registers \n*\n\"" \
      -ex "info registers" \
      -ex "printf \"*\n* Current instructions \n*\n\"" -ex "x/16i \$pc" \
      -ex "printf \"*\n* Threads (full) \n*\n\"" \
      -ex "info threads" \
      -ex "bt" \
      -ex "thread apply all bt full" \
      -ex "printf \"*\n* Threads (basic) \n*\n\"" \
      -ex "info threads" \
      -ex "thread apply all bt" \
      -ex "printf \"*\n* Done \n*\n\"" \
      -ex "detach" \
      -ex "quit" 

gdb -batch \
      -ex "set logging file $pid.log" \
      -ex "set logging on" \
      -ex "set pagination off" \
      -ex "attach $pid" \
      -ex "generate-core-file $pid.core" \
      -ex "detach" \
      -ex "quit" 

# Collect thread libs, etc
tar cvzf ${pid}.libs.tgz  /lib64/* /usr/lib64/* 

echo "--- Files to be collected:"
ls -l ${pid}*

