#!/usr/bin/bash

#
# Metronom script - beep once per minute
#


COUNTER=0
SLEEPSEC=58

if [ "$#" -eq 1 ]; then 
    SLEEPSEC=$1
fi
echo "Usage: $0 $SLEEPSEC"

while true; do
    let SERIE+=1
    echo -n "$SERIE:  "
    cat /cygdrive/c/Windows/Media/ringout.wav > /dev/dsp

    echo -n "`date +%T` "
    for i in `seq 1 $SLEEPSEC`; do
        DEC=$((i%10))
		NDEC=$((i/=10))
        if [[ $DEC -eq 0 ]]; then
            echo -n "$NDEC"
        else
            echo -n "."
        fi
        sleep 1
    done
    echo ""
done

