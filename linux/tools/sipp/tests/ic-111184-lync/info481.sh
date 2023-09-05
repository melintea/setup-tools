#!/bin/sh -x

# sipp Lync RCC (IC-111184) tests (UAC)

ICHOST=aurelianclay
#ICHOST=tsclayga_3

# http://sipp.sourceforge.net/doc/reference.html
# - 3sec calls (-d 3000), 5cps = -l 15
# - cacert.pem/cakey.pem(private)
# - -t l1: one TLS socket
# - -t t1: one TCP socket
~/work/sipp/sipp.src/sipp-3.3/sipp \
-t t1 -p 11001 -i 172.18.14.119 \
-sf info481.xml \
-s 8891 $ICHOST:11001 \
-d 300 -r 4 -l 3 \
-trace_logs -trace_msg -trace_err
