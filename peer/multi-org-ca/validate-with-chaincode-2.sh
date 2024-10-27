#!/bin/bash
#
# Validates the working of : secureOrderer Peer1 & secureOrderer Peer2
#

# Installs | commits on secureOrderer peer1
source ./validate-with-chaincode-1.sh

# Install the chaincode on secureOrderer peer2
PEER_NAME="peer2"
PEER_BASE_PORT=8050
source  set-env.sh  secureOrderer peer2 8050 admin


echo "====> 9. Installing $PACKAGE_NAME on secureOrderer Peer2"
peer lifecycle chaincode install  $CC2_PACKAGE_FOLDER/$PACKAGE_NAME

echo "====> 10. Querying for value of A in secureOrderer peer2"

peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'

echo "====> Value of A should be SAME on secureOrderer peer1 & peer2"
