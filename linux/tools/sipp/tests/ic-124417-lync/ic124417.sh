#!/bin/sh -x

# sipp Lync RCC (IC-124417) tests (UAC)

ICHOST=aurelianclay
#ICHOST=tsclayga_3
#ICHOST=

# http://sipp.sourceforge.net/doc/reference.html
# - 3sec calls (-d 3000), 5cps = -l 15
# - cacert.pem/cakey.pem(private)
# - -t l1: one TLS socket
# - -t t1: one TCP socket
# - -i local IP
# - -s user name part of the req uri => Lync (station) extension
# - -d <pause> duration in ms
# - -r call rate per sec
# - -l num simultaneous calls
# - -p local port
~/work/sipp/sipp.src/sipp-3.3/sipp \
-t t2 -p 11001 -i 172.18.14.108 \
-sf ic124417.xml \
-s 8891 $ICHOST:11001 \
-d 300 -r 4 -l 2 \
-trace_logs -trace_msg -trace_err
