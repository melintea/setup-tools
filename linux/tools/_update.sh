#!/bin/bash

# 
#
#

sudo apt update && sudo apt upgrade

sudo apt install \
apt apt-utils aptitude synaptic debianutils dpkg \
firefox  thunderbird  seamonkey \
keepass2 keepassxc \
gdisk gparted \
arp-scan bzip2 curl wget \
git git-guy gitk mc tree meld less nedit dos2unix vim \
ghostscript htop p7zip-full xz-utils zip \
autotools-dev binutils-dev build-essentials cmake make ninja-build \
bison flex g++ cgdb gdb clang lldb \
linux-tools-common linux-tools-generic linux-tools-`uname -r` \
google-perftools libgoogle-perftools-dev libbenchmark-dev graphviz \
adb fastboot \
rpi-imager \
rstudio 

