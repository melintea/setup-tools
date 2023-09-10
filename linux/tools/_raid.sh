#!/bin/bash

# 
# Check raid status. Must be root
# http://techie.org/Blog/2010/09/03/how-to-rebuild-intel-raid-isw-on-linux/
#

function run_cmd() {
    echo "=== $1"
    eval "${1}"
}

run_cmd "dmsetup status"
run_cmd "dmraid -r"
run_cmd "dmraid -s -s"
run_cmd "dmraid -tvay"
run_cmd "lsblk"

