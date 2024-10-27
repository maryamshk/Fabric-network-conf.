multi-org-ca Peer Scripts
=========================

1. Environment scripts:

    set-identity.sh
    ===============
    This script sets the variables from the identity perspective. 

    USAGE:   . set-identity.sh  ORG-Name [identity  defult=admin]

    set-env.sh
    ==========
    This script will set the environment variables for the PEER in a specific ORG. MUST be used with a '.'
    otherwise the environment vars will not take effect

    USAGE:   . set-env.sh   ORG_NAME   PEER_NAME  [PORT_NUMBER_BASE default=7050]  [Identity]

    If Identity is provided then the peer command executed with the MSP for that identity instead of
    the MSP for the peer

    show-env.sh
    ===========
    Shows the current environment setup for the peer. It is suggested that after using the 'set' script
    always use this script to ensure that the environment variables are set

    USAGE:   ./show-env.sh
    
2. Channel Scripts:

    sign-channel-tx.sh  T.B.D.
    ==========================
    Signs the airline channel file with the specified ORG's admin. 

    join-airline-channel.sh
    =======================
    Makes the specified peer join the channel.



Phase-1 Setup - Clean start
===========================
In phase 1 only two organizations will be setup 
- secureOrderer
- orderer

Orderer
------
<Instead of following these steps you may just exec ./run-all.sh>
1. Make sure you start clean - execute      
    ./clean.sh
2. Create the peer identity                 
    ./register-enroll-peer.sh    secureOrderer   peer1

<Instead of #3 & #4 you may exec ./init.sh>
3. Generate the genesis
    ./generate-genesis.sh
4. Generate the channel tx file
    ./generate-channel-tx.sh
5. Launch orderer

================
Peer (secureOrderer peer1)
=================
1. Make sure you start clean - execute   
    ./killall-peer.sh
    ./clean-peer-ledger-folder.sh secureOrderer peer1
2. Sign the channel. In phase 1 its optional as there is only 1 member org
    . set-env.sh secureOrderer peer1
    ./sign-channel-tx.sh  secureOrderer
3. Create the channel
    . set-env.sh secureOrderer peer1
    ./submit-create-channel.sh secureOrderer
4. Launch the peer
    ./launch-peer.sh   secureOrderer    peer1
5. Join the channel
    ./join-airline-channel.sh secureOrderer peer1 7050
6. Validate the peer
    peer channel list

Add Regular peer (peer2) to secureOrderer
=================================
1. Register the identity of peer2
./register-enroll-peer.sh  secureOrderer   peer2

2. . set-env.sh secureOrderer peer2 8050 admin

3. Launch
./launch-peer.sh secureOrderer peer2 8050

4. Join the channel
./join-airline-channel.sh secureOrderer peer2 8050

5. Validate by querying peer1 & peer2
./validate-with-chaincode-2.sh

====================================================================
Add the secOrg organization by following instructions in the lecture
=====================================================================

1. source   set-identity.sh secureOrderer admin

2. ./fetch-config-json.sh airlinechannel

3. cp ../../setup/config/multi-org-ca/yaml.1/configtx.yaml ./config

3.  ./add-member-org.sh 

4. ./generate-config-update.sh airlinechannel

5. ./sign-config-update.sh secureOrderer

6. ./submit-config-update-tx.sh secureOrderer admin airlinechannel

7. Fetch the channel - Block number will be > 0
   ./fetch-config-json.sh airlinechannel


=====================
Setup the secOrg Peer
=====================
1. Register and Enroll secOrg peer
 ./register-enroll-peer.sh secOrg secOrg-peer1

2. Launch peer
./launch-peer.sh secOrg secOrg-peer1 9050
   - Check logs to ensure there are no errors

3. Join secOrg peer to airline channel
./join-regular-peer-to-airlinechannel.sh secOrg secOrg-peer1 9050

4. Check if peer has joined the channel
. set-env.sh  secOrg  secOrg-peer1   9050
peer channel list

5. Validate
 ./validate-with-chaincode-3.sh


