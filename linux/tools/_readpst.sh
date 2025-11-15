#!/bin/bash

#
# https://www.linuxquestions.org/questions/linux-newbie-8/how-to-use-pst-utils-in-ubuntu-20-04-a-4175679631/
#

#readpst -M -b -e -o export_folder pst_archive.pst
readpst -b -u -o . $1
tree -apsDC .

