#!/bin/bash

#
# https://github.com/soxoj/maigret
# https://osintframework.com/
#

if [ $# -ne 1 ]
then
    echo "Need argument"
fi

maigret $@

