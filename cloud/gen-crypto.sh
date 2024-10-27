# FIRST TIME MUST call with 'all' as argument
# If 'all' not passed then crypto not regenrated

rm -rf temp
rm  -rf ./artefacts/*

#1 Check if all was passed
if [ ! -z $1 ]; then
    if [ $1 == "all" ]; then
        #1. Generate the crypto
        echo "====> Generating the crypto-config"
        rm -rf crypto-config
        cryptogen generate --config=./crypto-config.yaml
    fi
else
    echo 'Use ./gen-crypto.sh   all      to regenerate the crypto'
fi

echo    "====> Generating : Organization MSPs : orgs-msp.tar"
#2 Generate the orgs-msp.tar
rm -rf temp/orgs-msp
mkdir -p ./temp/orgs-msp/orderer
cp -R crypto-config/ordererOrganizations/secureOrderer.com/msp    temp/orgs-msp/orderer/msp
mkdir -p temp/orgs-msp/secureOrderer
cp -R crypto-config/peerOrganizations/secureOrderer.com/msp    temp/orgs-msp/secureOrderer/msp
mkdir -p temp/orgs-msp/secOrg
cp -R crypto-config/peerOrganizations/secOrg.com/msp    temp/orgs-msp/secOrg/msp 
# Create the orgs-msp tar file
cd temp
tar -c orgs-msp -f ../artefacts/orgs-msp.tar
cd ../

#3 Generate the orderer-msp.tar
echo   "====> Generating : Orderer MSP : orderer-msp.tar"
mkdir -p temp/orderer-msp
cp -R crypto-config/ordererOrganizations/secureOrderer.com/orderers/orderer.secureOrderer.com/msp  temp/orderer-msp
cd temp
tar -c orderer-msp -f ../artefacts/orderer-msp.tar
cd ../

#4 Generate the secureOrderer-msp.tar
echo   "====> Generating : secureOrderer MSP : secureOrderer-msp.tar"
mkdir -p temp/msps
cp -R crypto-config/peerOrganizations/secureOrderer.com/peers/firstOrg/msp                     temp/msps/peer
cp -R crypto-config/peerOrganizations/secureOrderer.com/users/Admin@secureOrderer.com/msp              temp/msps/admin
cp -R crypto-config/peerOrganizations/secureOrderer.com/users/User1@secureOrderer.com/msp              temp/msps/user1
cd temp
tar -c msps -f ../artefacts/secureOrderer-msp.tar
cd ../
rm -rf temp/msps/**

#5 Generate the secOrg-msp.tar
echo   "====> Generating : secOrg MSP : secOrg-msp.tar"
mkdir -p temp/msps
cp -R crypto-config/peerOrganizations/secOrg.com/peers/firstOrg/msp                       temp/msps/peer
cp -R crypto-config/peerOrganizations/secOrg.com/users/Admin@secOrg.com/msp              temp/msps/admin
cp -R crypto-config/peerOrganizations/secOrg.com/users/User1@secOrg.com/msp              temp/msps/user1
cd temp
tar -c msps -f ../artefacts/secOrg-msp.tar
cd ../
rm -rf temp/msps/*



