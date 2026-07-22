#!/bin/bash

#
#
#

/usr/bin/cpulimit --pid `pidof $1` --limit 5

