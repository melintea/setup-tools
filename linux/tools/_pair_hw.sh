#!/bin/bash

# A script to generate pairing data
# https://confluence.inin.com/display/PureCloud/How+to+manually+pair+a+Linux+Edge+hardware+appliance
 
function usage() {
        echo "Please specify an environment : dca | tca | sca"
}
 
if [[ $# -eq 0 ]]; then
        usage
    exit 1
fi
 
env=$1
 
if [[ "$env" != "dca"  &&  "$env" != "tca"  &&  "$env" != "sca" ]]; then
        echo "'$env' is not valid"
        usage
    exit 1
fi
 
if [[ ! -f ${ININ_EDGE_ROOT}/manuf/ininedgemanuf-l64r-1-0 ]]; then
        echo "manuf app does not exist: '${ININ_EDGE_ROOT}/manuf/ininedgemanuf-l64r-1-0'"
        exit 1
fi
 
 
rm -rf ${ININ_EDGE_RECOVERY}/certificates/
 
rm -rf ${ININ_EDGE_RECOVERY}/resources/
 
chmod +x ${ININ_EDGE_ROOT}/manuf/ininedgemanuf-l64r-1-0
${ININ_EDGE_ROOT}/manuf/ininedgemanuf-l64r-1-0 --client_cert=csr --uri https://pairing.us-east-1.inin${env}.com
 
# create directories
mkdir -p ${ININ_EDGE_RECOVERY}/certificates/pairing/trust/
mkdir -p ${ININ_EDGE_RECOVERY}/resources/update/trust/edge/
 
# Get the certificate to trust the pairing manager server
HASH=`curl -s http://edge-manufacturing.us-east-1.inindca.com/environments/inin${env}/trustHash`
curl -s http://edge-manufacturing.us-east-1.inindca.com/environments/inin${env}/trust > ${ININ_EDGE_RECOVERY}/certificates/pairing/trust/$HASH.0
 
# Sign the pairing client certificate
curl -s http://edge-manufacturing.us-east-1.inindca.com/environments/inin${env}/pairing_client_certificate --data-binary @${ININ_EDGE_RECOVERY}/certificates/pairing/client.csr > ${ININ_EDGE_RECOVERY}/certificates/pairing/client.cer
 
# Get the update service certificate
curl -s http://edge-manufacturing.us-east-1.inindca.com/environments/inin${env}/ininupdate_certificate > ${ININ_EDGE_RECOVERY}/resources/update/trust/edge/trusted.cer
 
echo complete

