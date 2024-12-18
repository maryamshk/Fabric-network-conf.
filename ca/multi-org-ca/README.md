Please NOTE:
============
The client and server subfolders are empty. Files will be generated on execution of the 
commands or scripts.

Motivation
==========
The crypto material in this folder replaces the cryptogen generated msp
In a real world scenario, the msp under this structure will be placed in
the appropriate folders on the independent physical/virtual server
folders.

References are being made to the crypto in the subfolders from the 
orderer/multi-org
peer/secureOrderer/multi-org
peer/secOrg/multi-org

PS:
===
TLS being ignored for the time being.

Scripts
=======
ca/multi-org-ca/run-all.sh      Will setup the Crypto for the muti-org-ca setup. It sets up the
                                - Org admins
                                - Org msps
                                - You still need to generate the Orderer & Peer identities
                                Use this script once you understand the identity management
                                in Fabric

ca/clean.sh             Cleans up the ./server & ./client folder
ca/setclient.sh         Sets the FABRIC_CA_CLIENT_HOME takes ORG and User. 
                        If args not provided current value shown
ca/add-admincerts.sh    Adds the admin's cert to msp/admincerts folder of the specified identity 


ca/server.sh                    (1) Initialize, Start/Stop CA Server, Enroll CA Server admin
                                    ./server.sh start
                                    ./server.sh enroll

ca/register-enroll-admins.sh    (2) Registers and enrolls the admins
                                    ./register-enroll-admins.sh

                                (2.1)  Set up org identity(s) + Add admin certs
                
ca/setup-org-msp.sh             (3) Setup the org msps









peer/launch-peer.sh  Launches the peer specified by ORG-Name & Peer_Name ... port number pending
peer/set-env.sh      Sets the environment vars for the provided ORG_Name & Peer
peer/show-env.sh     Shows the current environment

peer/config/generate-baseline.sh    Generates the baseline json configuration
peer/config/clean.sh                Deletes the json/pb/block files from the folder



Client MSP Folder
================

Roles & Identities
==================
1. admin            CA Server administrator
                    Created as a Bootstrap identity
                    ./server.sh enroll          Generates the MSP client/caserver/admin
                    The admin is then used to enroll other identities

2. orderer-admin    Orderer Org Administrator
                    Allowed to create the identities for Orderer Org
                    . ./setclient.sh caserver admin
                    fabric-ca-client register --id.type client --id.name orderer-admin --id.secret pw --id.affiliation orderer --id.attrs '"hf.Registrar.Roles=orderer"'
    
    * Set the CSR - its causing all identities to have a the default CSR - fix it :()

    2.1 Orderer admin now enrolls
    . ./setclient.sh orderer orderer-admin
    fabric-ca-client enroll -u http://orderer-admin:pw@localhost:7054

    2.2 Orderer admin registers the orderer identity
    . ./setclient.sh orderer orderer-admin
    fabric-ca-client register --id.type orderer --id.name orderer --id.secret pw --id.affiliation orderer 

    2.3 Orderer admin sets the FABRIC_CA_CLIENT_HOME and enrolls the orderer identity
    . ./setclient.sh orderer orderer
    fabric-ca-client enroll -u http://orderer:pw@localhost:7054


3. secureOrderer-admin       secureOrderer Org Adminstrator
                    Allowed to create the identities of type peer, user & client for secureOrderer Org
                    Allowed to manage affiliation

                    . ./setclient.sh caserver admin

                    fabric-ca-client register --id.type client --id.name secureOrderer-admin --id.secret pw --id.affiliation secureOrderer --id.attrs '"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true"'

    3.1 secureOrderer admin now enrolls

    . setclient.sh secureOrderer secureOrderer-admin
    fabric-ca-client enroll -u http://secureOrderer-admin:pw@localhost:7054

    3.2 secureOrderer admin registers user identity (jdoe) for secureOrderer organization

        3.2.1   Create a user identity "John Doe"  Id=jdoe Secret=pw Affiliation=secureOrderer Logistics Type=user

        . setclient.sh secureOrderer secureOrderer-admin
        fabric-ca-client register --id.type client --id.name jdoe --id.secret pw --id.affiliation secureOrderer.logistics 

        3.2.2   John Doe - enrolls as a user

        . setclient.sh secureOrderer jdoe
        fabric-ca-client enroll -u http://jdoe:pw@localhost:7054

    3.3 secureOrderer admin registers user identity for a peer - peer1

        3.3.1  Create the peer identity "peer1" Id=peer1 Secret=pw Affiliation=secureOrderer Type=peer
        . setclient.sh secureOrderer secureOrderer-admin
        fabric-ca-client register --id.type peer --id.name peer1 --id.secret pw --id.affiliation secureOrderer

        3.3.2  secureOrderer admin enrolls the peer1
        . setclient.sh secureOrderer peer1
        fabric-ca-client enroll -u http://peer1:pw@localhost:7054

MSP Setup
=========
* Rename admin cert as part of the copy PENDING

ADMIN Certificate is Needed in all local MSP

1. Setup the MSP for the Orderer Organization/Member

    . setclient.sh secureOrderer secureOrderer-admin

    * Copy CA Cert
    mkdir -p ./client/orderer/msp/cacerts
    cp ./server/ca-cert.pem ./client/orderer/msp/cacerts

    * Copy Admin Cert
    mkdir -p ./client/orderer/msp/admincerts
    cp ./client/orderer/orderer-admin/msp/signcerts/*   ./client/orderer/msp/admincerts



2. Setup the MSP for secureOrderer Organization

    . setclient.sh secureOrderer secureOrderer-admin

    * Copy CA Cert
    mkdir -p ./client/secureOrderer/msp/cacerts
    cp ./server/ca-cert.pem ./client/secureOrderer/msp/cacerts

    * Copy Admin Cert
    mkdir -p ./client/secureOrderer/msp/admincerts
    cp ./client/secureOrderer/secureOrderer-admin/msp/signcerts/*   ./client/secureOrderer/msp/admincerts

    * Copy the Admin cert to secureOrderer-admin folder also
    mkdir -p ./client/secureOrderer/secureOrderer-admin/msp/admincerts
    cp ./client/secureOrderer/secureOrderer-admin/msp/signcerts/*   ./client/secureOrderer/secureOrderer-admin/msp/admincerts

    * Copy the Admin cert to peer1 folder also
    mkdir -p ./client/secureOrderer/peer1/msp/admincerts
    cp ./client/secureOrderer/secureOrderer-admin/msp/signcerts/*   ./client/secureOrderer/peer1/msp/admincerts

    * Copy the Admin cert to jdoe folder also
    mkdir -p ./client/secureOrderer/jdoe/msp/admincerts
    cp ./client/secureOrderer/secureOrderer-admin/msp/signcerts/*   ./client/secureOrderer/jdoe/msp/admincerts

3. Setup the MSP for Orderer

    * Need to set the admin for the Orderer
    mkdir -p ./client/orderer/orderer/msp/admincerts
    FIX THIS - it should be Orderer Admin NOT secureOrderer-admin
    cp ./client/secureOrderer/secureOrderer-admin/msp/signcerts/*  ./client/orderer/orderer/msp/admincerts

Exercise-Create the MSP for secOrg
==================================
The generated MSP will be used in the recipe for adding the Org/secOrg

1. Update the affiliation 
   Add secOrg to it

   . ./setclient.sh caserver admin

   fabric-ca-client affiliation list
   fabric-ca-client affiliation add secOrg


2. secOrg-admin     secOrg Org Adminstrator
                    Allowed to create the identities of type peer, user & client for secOrg Org
                    Allowed to manage affiliation

                    . ./setclient.sh caserver admin

                    fabric-ca-client register --id.type client --id.name secOrg-admin --id.secret pw --id.affiliation secOrg --id.attrs '"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true"'


3. As secOrg-admin enroll
    . ./setclient.sh secOrg secOrg-admin
    fabric-ca-client enroll -u http://secOrg-admin:pw@localhost:7054
    This will generte the crypto under ca/multi-org-ca/client/secOrg

4. Add admin cert to secOrg-admin

5. Setup MSP for secOrg
    4.1 Create folder msp under the secOrg org
    mkdir -p client/secOrg/msp/admincerts
    mkdir -p client/secOrg/msp/cacerts
    mkdir -p client/secOrg/msp/keystore

    4.2 Copy the CA Cert
    cp ./server/ca-cert.pem ./client/secOrg/msp/cacerts

    4.3 Copy the admin cert
    cp ./client/secOrg/secOrg-admin/msp/signcerts/*   ./client/secOrg/msp/admincerts

    4.4 setup admincerts in secOrg-admin/msp  [Otherwise gives an error]
    mkdir -p ./client/secOrg/secOrg-admin/msp/admincerts
    cp ./client/secOrg/secOrg-admin/msp/signcerts/*   ./client/secOrg/secOrg-admin/msp/admincerts/*   

Write a script that would setup the MSP for an org



Configtx.Yaml Setup
===================
* COPYING of policy.0 configtx PENDING

Copy the setup/config/ca/multi-org-ca/policy.0/configtx.yaml   orderer/multi-org-ca

Launch orderer

Airline Channel Creation
========================
secureOrderer Admin will take the role of (AirlineChannel) channel creator
Although the policy is MAJORITY admin it would 

* Copy the core.yaml file from policy.0 to peer/multi-org-ca/secureOrderer
Used by peer binary for admin commands only. It points to the admin MSP - so that admin can take appropriate actions


#PENDING

* Copy the orderer/multi-org-ca/airline-channel.tx to peer/multi-org-ca/secureOrderer
cp ../../../orderer/multi-org-ca/airline-channel.tx  .

peer channel create -o localhost:7050 -c airlinechannel -f ./airline-channel.tx

secureOrderer Peer1 Setup & Launch
=========================
./launch-peer.sh  secureOrderer peer1

./join-airline-channel.sh secureOrderer peer1

Test setup
==========

. set-env.sh secureOrderer secureOrderer-admin

* Install the chain code as secureOrderer-admin 
peer chaincode install  -n gocc -v 1.0  -p chaincode_example02
peer chaincode list --installed

* Instantiate the chaincode as secureOrderer-admin
peer chaincode instantiate  -n gocc -v 1.0 -C airlinechannel -c '{"Args":["init","a","100","b","200"]}'

peer chaincode list --instantiated -C airlinechannel

* Execute the chaincode as secureOrderer-admin
   peer chaincode query -C airlinechannel -n gocc  -c '{"Args":["query","a"]}'
   peer chaincode invoke -C airlinechannel -n gocc  -c '{"Args":["invoke","a","b","10"]}'

* Execute the chaincode as user
 . set-env.sh secureOrderer jdoe
    - Query execute will go through but install/instantiate will fail as the type of identity is user 
    - Install will fail     peer chaincode install  -n gocc -v 1.0  -p chaincode_example02
    Refer to the policy => getinstalledchaincodes

Recipe: Add a peer to secureOrderer org
==============================
1. secureOrderer Admin needs to set up the identity of peer2 &  MSP
    . setclient.sh secureOrderer secureOrderer-admin

    1.1 Register the identity "peer2" Id=peer2 Secret=pw Affiliation=secureOrderer Type=peer
        
        fabric-ca-client register --id.type peer --id.name peer2 --id.secret pw --id.affiliation secureOrderer

    1.2 secureOrderer admin enrolls the peer2
        . setclient.sh secureOrderer peer2
        fabric-ca-client enroll -u http://peer2:pw@localhost:7054

    1.3 secureOrderer Admin sets up peer2's local MSP
        mkdir -p ./client/secureOrderer/peer2/msp/admincerts
        cp ./client/secureOrderer/secureOrderer-admin/msp/signcerts/*   ./client/secureOrderer/peer2/msp/admincerts

2. Setup the Peer peer2 for secureOrderer
   peer/multi-org-ca/peer

    2.1 Launch the peer
        ./launch-peer.sh secureOrderer peer2 8050

    2.2 Peer2 to join the channel
        . set-env.sh secureOrderer peer2 8050 admin
        ./join-airline-channel.sh secureOrderer peer2

3. Test the Peer2

. set-env.sh secureOrderer secureOrderer-admin

* Install the chain code as secureOrderer-admin 

peer chaincode install  -n gocc -v 1.0  -p chaincode_example02
peer chaincode list --installed

* No need to instantiate as it is already done

* Execute the chaincode as secureOrderer-admin
   peer chaincode query -C airlinechannel -n gocc  -c '{"Args":["query","a"]}'
   peer chaincode invoke -C airlinechannel -n gocc  -c '{"Args":["invoke","a","b","10"]}'

Recipe: Add an anchor peer to secureOrderer
==================================
This would require a Network level configuration change.

There are 2 sceanrios
1. Existing Peer added as an acnchor peer
2. New peer added as an anchor peer

multi-org-ca/peer
. set-env.sh secureOrderer secureOrderer-admin 7050
cd to config 

1. Fetch the latest configuration
peer channel fetch config config_block_original.pb -o localhost:7050 -c ordererchannel

2. Convert to JSON
configtxlator proto_decode --type=common.Block --input=config_block_original.pb > config_block_original.json

3. Extract the config branch
jq .data.data[0].payload.data.config config_block_original.json > config_original.json

4. Make a copy of the config_original.json
cp config_original.json config_updated.json

5. Add another "anchor" peer for secureOrderer in config_updated.json
                    {
                      "host": "localhost",
                      "port": 8051
                    }   
6. Encode the original & updated
configtxlator proto_encode --input config_original.json --output config_original.block --type common.Config
configtxlator proto_encode --input config_updated.json --output config_updated.block --type common.Config

7. Compute the delta 
configtxlator compute_update --channel_id ordererchannel  --original config_original.block --updated config_updated.block --output config_update_delta.block

8. Convert to JSON (optional step for dleta inspection)
configtxlator proto_decode --input config_update_delta.block --type common.ConfigUpdate --output=config_update_delta.json
Checkout the content of this JSON it just has the difference between orginal and updated

9. echo '{"payload":{"header":{"channel_header":{"channel_id":"'ordererchannel'", "type":2}},"data":{"config_update":'$(cat config_update_delta.json)'}}}' | jq . > config_update_in_envelope.json

10. Create the proto buf from the updated
configtxlator proto_encode --input config_update_in_envelope.json --type common.Envelope --output config_update_in_envelope.block

Sign & Update
=============
Admin signs the config block
peer channel signconfigtx -f config_update_in_envelope.block

Since only one admin is needed to sign
peer channel update -f config_update_in_envelope.block -c ordererchannel -o localhost:7050

Recipe: Add an Org secOrg to Network
====================================

ca/multi-org-ca

1. Generate the crypto material for secOrg
ca/multi-org-ca

multi-org-ca/config

2. Setup configtxgen YAML with params for secOrg
- get the configtxgen.yaml 
cp ../../../orderer/multi-org-ca/configtx.yaml .
FABRIC_CFG_PATH=$PWD/.. && configtxgen -channelID ordererchannel -printOrg secOrg > secOrg.json
(Solution=setup/config/multi-org-ca/policy.1)



3. Extract config GENERATE THE BASELINE FOR CONFIG

peer/config/generate-baseline.sh ordererchannel

peer channel fetch config config_block_original.pb -o localhost:7050 -c ordererchannel
configtxlator proto_decode --type=common.Block --input=config_block_original.pb > config_block_original.json
jq .data.data[0].payload.data.config config_block_original.json > config_original.json

4. Add the secOrg org - create the config_updated.json
jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"secOrg":.[1]}}}}}' config_original.json secOrg.json > config_updated.json

At this point two JSON files
config_original.json     Has secureOrderer orgs
config_updated.json      Has secureOrderer and secOrg orgs

5. Create the delta

Convert original & updated to pb - this is needed for generating the delta

configtxlator proto_encode --input config_original.json --type common.Config --output config_original.pb
configtxlator proto_encode --input config_updated.json --type common.Config --output config_updated.pb

configtxlator compute_update --channel_id ordererchannel --original config_original.pb --updated config_updated.pb --output secOrg_update.pb



Script:
create-update-pb


6. Convert update & Wrap in the envelope

configtxlator proto_decode --input secOrg_update.pb --type common.ConfigUpdate | jq . > secOrg_update.json

echo '{"payload":{"header":{"channel_header":{"channel_id":"ordererchannel", "type":2}},"data":{"config_update":'$(cat secOrg_update.json)'}}}' | jq . > secOrg_update_in_envelope.json

configtxlator proto_encode --input secOrg_update_in_envelope.json --type common.Envelope --output secOrg_update_in_envelope.pb

7. Sign and send update transaction
peer channel signconfigtx -f secOrg_update_in_envelope.pb
peer channel update -f secOrg_update_in_envelope.pb -c ordererchannel -o localhost:7050

8. Verify
./clean.sh
./generate-baseline.sh ordererchannel
Chec out the config_original.json - look for secOrg

Recipe - add the secOrg to airline channel
==========================================

Setup the secOrg peer1:
=======================
1. secOrg admin creates the crypto for peer1
ca/multi-org-ca

- setup the peer identity
. ./setclient.sh secOrg secOrg-admin
fabric-ca-client register --id.type peer --id.name secOrg-peer1 --id.secret pw --id.affiliation secOrg

-  admin enrolls the peer1
    . setclient.sh secOrg peer1
    fabric-ca-client enroll -u http://secOrg-peer1:pw@localhost:7054

- set up MSP for the peer

    Create folder msp under the secOrg org
    mkdir -p client/secOrg/peer1/msp/admincerts

    Copy the admin cert
    cp ./client/secOrg/secOrg-admin/msp/signcerts/*   ./client/secOrg/peer1/msp/admincerts

2. Copy the core.yaml from setup/config/multi-org-ca/policy.0 to peer/multi-org-ca/secOrg
cp 

3. Launch and check logs
./launch-peer.sh secOrg peer1 9050

[Join, Chaincode install were successful *but* chaincode query failed with access denied]


Add the secOrg to airline channel
=================================
Since only secureOrderer-admin has the access. The secureOrderer-admin will carry out the following task.

peer/multi-org-ca
. set-env.sh secureOrderer secureOrderer-admin 7050 secureOrderer-admin

 
cd config


1. 
FABRIC_CFG_PATH=$PWD/.. && configtxgen -channelID airlinechannel -printOrg secOrg > secOrg.json

2.
./generate-baseline.sh

3. Setup the updated JSON

jq -s '.[0] * {"channel_group":{"groups":{"Application":{"groups": {"secOrg":.[1]}}}}}' config_original.json secOrg.json > config_updated.json

4. Compute the delta
./create-update-pb.sh airlinechannel   
this outputs the file >> config_update_output.pb

5. 

./create-update-envelope-pb.sh airlinechannel

Generates the file : config_update_output_in_envelope.pb

6. 

peer channel signconfigtx -f config_update_output_in_envelope.pb
peer channel update -f config_update_output_in_envelope.pb -c airlinechannel -o localhost:7050

7. Validate
. set-env.sh 

   peer chaincode query -C airlinechannel -n gocc  -c '{"Args":["query","a"]}'
   peer chaincode invoke -C airlinechannel -n gocc  -c '{"Args":["invoke","a","b","10"]}'
   
Exercise - thought
==================
Create an identity that will act as the admin for secureOrderer.logistics apps????







