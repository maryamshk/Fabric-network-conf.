# The Policy for App Channel Creation = MAJORITY of Admins
# This utility leads to signing of the airline channel txn file by secureOrderer & secOrg
CONFIG_FOLDER=$PWD/../../orderer/multi-org
CRYPTO_FOLDER=$CONFIG_FOLDER/crypto-config

function signChannelTxFile {
    FABRIC_CFG_PATH=$PWD/$ORG_NAME
    CORE_PEER_MSPCONFIGPATH=$CRYPTO_FOLDER/peerOrganizations/$ORG_NAME.com/users/Admin@$ORG_NAME.com/msp
    CORE_PEER_FILESYSTEMPATH=/home/vagrant/ledgers/peer/multi-org/$ORG_NAME/ledger
    peer channel signconfigtx -f $CONFIG_FOLDER/airline-channel.tx
}

# Sign the Airline-Channel Tx file as secureOrderer
ORG_NAME=secureOrderer
export FABRIC_CFG_PATH=$PWD/$ORG_NAME
signChannelTxFile
echo "Signed the tx as secureOrderer"

# Sign the Airline-Channel Tx file as secOrg
ORG_NAME=secOrg
export FABRIC_CFG_PATH=$PWD/$ORG_NAME
signChannelTxFile
echo "Signed the tx as secOrg"

peer channel create -o localhost:7050 -c airlinechannel -f $CONFIG_FOLDER/airline-channel.tx
