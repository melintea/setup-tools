#!/bin/bash

# 
#
#

colordiff -y <(xxd "$1") <(xxd "$2")
