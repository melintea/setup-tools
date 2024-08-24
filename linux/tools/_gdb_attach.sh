#!/bin/bash

#
# Run as root
# Attach gdb to $1
#

gdb -ex "attach `pidof $1`"
