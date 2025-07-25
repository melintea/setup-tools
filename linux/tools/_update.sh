#!/bin/bash

# 
#
#

sudo apt update && sudo apt upgrade

sudo apt install \
apt apt-utils aptitude synaptic debianutils dpkg \
rpi-imager \
firefox  thunderbird  seamonkey \
keepass2 keepassxc \
gdisk gparted \
arp-scan bzip2 curl wget \
git git-gui gitk mc tree meld xxdiff diffuse less nedit dos2unix vim jq rcs moreutils \
ghostscript htop p7zip-full xz-utils zip \
autotools-dev binutils-dev build-essentials cmake make ninja-build checkinstall \
bison flex g++ cgdb gdb clang clang-tidy lldb rr \
zeal doxygen graphviz \
linux-tools-common linux-tools-generic linux-tools-`uname -r` \
google-perftools libgoogle-perftools-dev libbenchmark-dev graphviz \
papi-tools papi-examples libpapi-dev \
adb fastboot \
rstudio 

