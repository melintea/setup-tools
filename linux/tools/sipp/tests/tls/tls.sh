#!/bin/sh -x

# sipp TLS tests

ICHOST=aurelianclay
#ICHOST=tsclayga_3

# - 3sec calls (-d 3000), 5cps = -l 15
# - cacert.pem/cakey.pem(private)
# - -t l1: one TLS socket
~/work/sipp/sipp.src/sipp-3.3/sipp \
-sf uac.xml \
-s 8891 $ICHOST:5061 \
-t l1 \
-tls_cert ../../$ICHOST/am90121dCertificate.cer \
-tls_key  ../.../$ICHOST/am90121dPrivateKey.bin \
-d 20000 -l 1 \
-trace_logs -trace_msg
