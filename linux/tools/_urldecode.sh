#!/bin/bash

#
# cat in.txt | while read; do echo -e ${REPLY//%/\\x}; done > res.txt
#

while read; do echo -e ${REPLY//%/\\x}; done

