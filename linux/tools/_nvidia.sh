#!/bin/bash

#
# Check NVIDIA drivers 
#

function run_cmd() {
    echo "=== $1"
    eval "${1}"
}

run_cmd "ubuntu-drivers devices"
run_cmd "nvidia-smi"

