#!/bin/bash

# 
# Disable an app
# Use App Inspector
#

pkg=$1

adb devices

adb shell pm disable-user --user 0 ${pkg} 
adb shell pm list packages -d 

#adb shell pm enable ${pkg} 
