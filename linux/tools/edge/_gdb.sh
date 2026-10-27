#!/bin/bash

ps -ef | grep inin
sudo /opt/rh/devtoolset-7/root/usr/bin/gdb $@
 
