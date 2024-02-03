#!/bin/bash

# 
#
#

#difftool='colordiff -y' 
difftool='vimdiff'

${difftool} <(xxd "$1") <(xxd "$2")
