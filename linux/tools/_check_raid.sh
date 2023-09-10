#!/bin/sudo /bin/bash

# 
# Check raid status. Must be root
# http://techie.org/Blog/2010/09/03/how-to-rebuild-intel-raid-isw-on-linux/
# https://romaco.ca/blog/2012/05/28/recover-raid-array-with-dmraid/
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

function run_cmd() {
    echo "=== $1"
    eval "${1}"
}

dmres=`/usr/sbin/dmraid -s -s`
uptm=`uptime`
retval=$?
if [[ $? != 0 || ! $dmres =~ "status : ok" ]]; then
    echo "${dmres}" | mail -s "RAID failure" -a "X-Priority:1" -a "From: ame01@gmx.net" ame01@gmx.net
    print "${RED}" "FAIL WITH: ${retval}\n${dmres}\n"
    run_cmd "/usr/sbin/dmsetup status"
    run_cmd "/usr/sbin/dmraid -r"
    run_cmd "/usr/sbin/dmraid -tvay"
    run_cmd "/usr/bin/lsblk"
else
    print "${dmres}\n\n${uptm}" | mail -s "RAID status: ok" -a "From: ame01@gmx.net" ame01@gmx.net
    print "${GREEN}" "Ret=${retval}\n${dmres}"
fi

