#!/bin/bash

# 
# To next/trixie Pi OS
# 
# https://forums.raspberrypi.com/viewtopic.php?t=392376
# https://gist.github.com/jauderho/5f73f16cac28669e56608be14c41006c
#

fromdist=bookworm
todist=trixie

sudo su

apt update && sudo apt full-upgrade
pisafe

sed -i "s/${fromdist}/${todist}/g" /etc/apt/sources.list
find /etc/apt/sources.list.d -type f -exec sed -i "s/${fromdist}/${todist}/g" {};

apt update
apt purge -y raspberry-ui-mods
apt autoremove -y

# apt upgrade --download-only # /var/cache/apt/archives/
apt full-upgrade -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confnew" --purge --auto-remove

apt install -y rpd-wayland-all rpd-x-all
#apt install -y raspberry-ui-mods

apt install --reinstall raspberrypi-archive-keyring

