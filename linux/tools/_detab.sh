#!/bin/bash

#  get rid of tabs in file

if [$# -ne 1]; then
    echo "usage: $0 file"
    exit 1
fi

/usr/bin/expand -t 4 "$1" | /usr/bin/sponge "S1"
