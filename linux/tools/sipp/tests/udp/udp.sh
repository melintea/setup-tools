#!/bin/sh -x

# Plain calls to CIC/Edge

#ICHOST=aurelianclay
#ICHOST=tsclayga_3
ICHOST=aurelianedge

# http://sipp.sourceforge.net/doc/reference.html
# - 3sec calls (-d 3000), 5cps = -l 15
# - cacert.pem/cakey.pem(private)
# - -t l1: one TLS socket
# - -t t1: one TCP socket
# - -i local IP 
# - -s user name part of the req uri => user / station extension
# - -d <pause> duration in ms
# - -r call rate per sec
# - -l num simultaneous calls
# - -p local port
~/work/sipp/sipp.src/sipp-3.3/sipp \
-t u2 -p 11001 -i 172.18.14.120 \
-sf uac.xml \
-s 8891 $ICHOST:5060 \
-d 30000 -r 4 -l 1 \
-trace_logs -trace_msg -trace_err
