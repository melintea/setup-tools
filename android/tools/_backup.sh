#!/bin/bash

# 
#
#

adb devices

adb backup -apk -shared -all -f ./ufone14backup.ab

adb restore -f ./ufone14backup.ab

