#!/bin/bash

# 
#
#

difftool=colordiff 
#difftool=vimdiff

${difftool} -y <(xxd "$1") <(xxd "$2")
