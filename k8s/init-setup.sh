#!/bin/bash

#1. Clean up earlier setup
echo    "====>Cleanup the earlier runs"
./clean-all.sh

#2. Generate the crypto
echo    "====>Generating the crypto"
cd config
cryptogen generate --config=crypto-config.yaml

#3. Generate the genesis
echo    "====>Generating the genesis block"
export FABRIC_CFG_PATH=$PWD
configtxgen -outputBlock  ./orderer/airlinegenesis.block -channelID ordererchannel  -profile AirlineOrdererGenesis

#4. Generate the channel create tx
echo    "====>Generating the channel create tx"
configtxgen -outputCreateChannelTx  airlinechannel.tx -channelID airlinechannel  -profile AirlineChannel


PEER_FABRIC_CFG_PATH=$FABRIC_CFG_PATH

#5. Generate the anchor update secureOrderer
ORG_NAME=secureOrderer
configtxgen -outputAnchorPeersUpdate ./secureOrderer-peer-update.tx   -asOrg $ORG_NAME -channelID airlinechannel  -profile AirlineChannel

#6. Generate the anchor peer update secOrg
ORG_NAME=secOrg
configtxgen -outputAnchorPeersUpdate ./secOrg-peer-update.tx   -asOrg $ORG_NAME -channelID airlinechannel  -profile AirlineChannel

echo "Done."