#!/bin/sudo /bin/bash

# 
# Check raid status. Must be root
# Find assigned IP
#
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

uptm=`uptime`
if [[ -f /usr/sbin/dmraid ]]; then
  dmres=`/usr/sbin/dmraid -s -s`
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
fi

if [[ -f /proc/mdstat ]]; then
  mdres=`cat /proc/mdstat`
  subj=`echo "${mdres}" | grep 'blocks super'`
  if [[ ! $subj =~ "[2/2] [UU]" ]]; then
      echo "${mdres}" | mail -s "FAILED mdraid: ${subj}" -a "From: ame01@gmx.net" ame01@gmx.net
  else
      echo "${mdres}" | mail -s "OK mdraid: ${subj}" -a "From: ame01@gmx.net" ame01@gmx.net
  fi
fi

# ------------------------------------------------------------------------

#!/bin/bash

INTERFACE="wlx0022c0164693"
TIMEOUT=10
INTERVAL=2

#echo "Waiting for IP address on $INTERFACE..."
start_time=$(date +%s)
while true; do
    ip_address=$(ip -4 addr show $INTERFACE | grep -oP 'inet\s+\K[\d.]+')

    if [ -n "$ip_address" ]; then
        echo "IP address assigned: $ip_address"
        break
    fi

    current_time=$(date +%s)
    elapsed_time=$((current_time - start_time))

    if [ "$elapsed_time" -ge "$TIMEOUT" ]; then
        echo "Timeout: No IP address assigned to $INTERFACE within $TIMEOUT seconds."
        break
    fi

    sleep "$INTERVAL"
done

ip addr list | grep inet | mail -s "IP" -a "From: ame01@gmx.net" ame01@gmx.net
