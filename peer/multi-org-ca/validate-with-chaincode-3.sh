#!/bin/bash
#
# Validates the working of : secureOrderer Peer1 & secOrg Peer1
#
# Installs | commits on secureOrderer peer1
source ./validate-with-chaincode-1.sh

# Install the chaincode on secureOrderer peer2
PEER_NAME="secOrg-peer1"
PEER_BASE_PORT=9050
source  set-env.sh  secOrg peer2 9050 admin


echo "====> Step 10. Installing $PACKAGE_NAME on secOrg peer1"
. set-identity.sh secOrg admin
peer lifecycle chaincode install  $CC2_PACKAGE_FOLDER/$PACKAGE_NAME


# Get the package ID
cc_get_package_id

echo "====> Step 11. Approve the chaincode for secOrg"
peer lifecycle chaincode approveformyorg --channelID $CC_CHANNEL_ID  --name $CC_NAME \
            --version $CC_VERSION --package-id $PACKAGE_ID --sequence $CC2_SEQUENCE \
            $CC2_INIT_REQUIRED    -o $ORDERER_ADDRESS  --waitForEvent


echo "====> Step 12. Querying for value of A in secOrg peer1"

peer chaincode query -C $CC_CHANNEL_ID -n $CC_NAME  -c '{"Args":["query","a"]}'

echo "====> Value of A should be SAME on secureOrderer peer1 & peer2"