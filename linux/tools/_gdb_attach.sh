#!/bin/bash

#
# Run as root
# Attach gdb to $1
#

cgdb -ex "attach `pidof $1`"
