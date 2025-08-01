#!/bin/sh -x

# Plain calls to CIC/Edge

#ICHOST=aurelianclay
#ICHOST=tsclayga_3
ICHOST=10.254.64.204

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
sipp \
-t u2 -p 11001 -i 10.254.64.199 \
-sf uac.xml \
-s 13176435502 $ICHOST:5060 \
-d 25000 \
-r 4 \
-l 100 \
-trace_logs -trace_msg -trace_err
