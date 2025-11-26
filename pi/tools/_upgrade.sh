#!/bin/bash

# 
# To trixie Pi OS
# https://forums.raspberrypi.com/viewtopic.php?t=392376
#

sudo su

apt update && sudo apt full-upgrade
pisafe

sed -i 's/bookworm/trixie/g' /etc/apt/sources.list
find /etc/apt/sources.list.d -type f -exec sed -i 's/bookworm/trixie/g' {};

apt update
apt purge -y raspberry-ui-mode
apt autoremove -y

apt full-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" --purge --auto-remove

apt install -y rpd-wayland-all rpd-x-all

