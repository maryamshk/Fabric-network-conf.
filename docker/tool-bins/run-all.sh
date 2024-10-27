#!/bin/bash

############################
# Setup anchor peer for secureOrderer
# Set the context
. set-context.sh secureOrderer

# Submit the channel create tx
./submit-channel-create.sh

# Give time for the channel tx to propagate
sleep 3s

# Join secureOrderer peer to the channel
./join-channel.sh

sleep 3s

# Update anchor peer in channel
./anchor-update.sh

############################
# Setup anchor peer for secOrg
# Set the context
. set-context.sh secOrg

# Join the secOrg peer
./join-channel.sh

sleep 3s

# Update anchor peer in channel
./anchor-update.sh