# Make sure that IP Addresses are setup properly
# Use PUBLIC IP Here


export ORDERER_ADDRESS=54.84.11.141:7050

export secureOrderer_EP=52.205.172.116:7051
export secOrg_EP=100.25.153.169:7051



# Ignore for the time being :)
export EXPO_EP=54.87.106.2:7051

FABRIC_CFG_PATH=$PWD

# Test Chaincode related properties
export CC_CONSTRUCTOR='{"Args":["init","a","100","b","200"]}'
export CC_NAME="gocc1"
export CC_PATH="chaincode_example02"
export CC_VERSION="1.0"
export CC_CHANNEL_ID="airlinechannel"
export CC_LANGUAGE="golang"

# Version 2.x
export INTERNAL_DEV_VERSION="1.0"
export CC2_PACKAGE_FOLDER="$HOME/packages"
export CC2_SEQUENCE=1
export CC2_INIT_REQUIRED="--init-required"

# Create the package with this name
export PACKAGE_NAME="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION.tar.gz"
# Extracts the package ID for the installed chaincode
export LABEL="$CC_NAME.$CC_VERSION-$INTERNAL_DEV_VERSION"



export FABRIC_LOGGING_SPEC=info

function    usage {
    echo  "Usage: . ./set-env.sh    ORG_NAME"
    echo  "Sets the environment for the specific org"
}

export CURRENT_ORG_NAME=$1

echo "Setting environment for $CURRENT_ORG_NAME"

# Set environment variables based on the ORG_Name
case $CURRENT_ORG_NAME in
    "secureOrderer")   export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/.com/users/Admin@secureOrderer.com/msp
              export CORE_PEER_ADDRESS=$secureOrderer_EP
              export CORE_PEER_LOCALMSPID=secureOrdererMSP
        ;;
    "secOrg") export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/secOrg.com/users/Admin@secOrg.com/msp
              export CORE_PEER_ADDRESS=$secOrg_EP
              export CORE_PEER_LOCALMSPID=secOrgMSP
        ;;
    "expo")   export CORE_PEER_MSPCONFIGPATH=./crypto-config/peerOrganizations/expo.com/users/Admin@expo.com/msp
              export CORE_PEER_ADDRESS=$EXPO_EP
              export CORE_PEER_LOCALMSPID=ExpoMSP
        ;;
    

    *) usage
esac