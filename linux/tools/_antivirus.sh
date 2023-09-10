#!/bin/bash -e

#
# Update antivirus database.  Must be run as root. 
#

#freshclam -v
clamscan --version
systemctl status clamav-daemon

systemctl  stop  clamav-freshclam 
sudo freshclam
systemctl  start clamav-freshclam 

# clamscan
