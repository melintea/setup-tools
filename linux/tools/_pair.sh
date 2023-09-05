#!/bin/bash

#
# https://confluence.inin.com/display/PureCloud/How+to+manually+pair+a+Linux+Edge+hardware+appliance
# https://confluence.inin.com/display/PureCloud/Manufacturing+and+Pairing+a+Linux+Edge+in+DCA
#

if [ -z "${ININ_EDGE_ROOT}" ]; then
    echo "Need to set ININ_EDGE_ROOT. Source  //users/aurelian.melinte_systest/linux/setup/_amelinte"
    exit 1
fi
if [ -z "${ININ_EDGE_RECOVERY}" ]; then
    echo "Need to set ININ_EDGE_RECOVERY. Source  //users/aurelian.melinte_systest/linux/setup/_amelinte"
    exit 1
fi

chmod +x ${ININ_EDGE_ROOT}/manuf/ininedgemanuf-l64d-1-0
${TIER_ROOT_EDGE}/pub/gen/bin/l64/ininedgemanuf-l64d-1-0 --client_cert csr --uri https://pairing.us-east-1.inindca.com

# create directories
mkdir -p ${ININ_EDGE_RECOVERY}/certificates/pairing/trust/
mkdir -p ${ININ_EDGE_RECOVERY}/resources/update/trust/edge/
 
# Get the certificate to trust the pairing manager server
HASH=`curl http://edge-manufacturing.us-east-1.inindca.com/environments/inindca/trustHash`
curl http://edge-manufacturing.us-east-1.inindca.com/environments/inindca/trust > ${ININ_EDGE_RECOVERY}/certificates/pairing/trust/$HASH.0
 
# Sign the pairing client certificate
curl http://edge-manufacturing.us-east-1.inindca.com/environments/inindca/pairing_client_certificate --data-binary @${ININ_EDGE_RECOVERY}/certificates/pairing/client.csr > ${ININ_EDGE_RECOVERY}/certificates/pairing/client.cer
# Get the update service certificate
curl http://edge-manufacturing.us-east-1.inindca.com/environments/inindca/ininupdate_certificate > ${ININ_EDGE_RECOVERY}/resources/update/trust/edge/trusted.cer

echo "Done."
