#!/bin/bash

############################
# Setup anchor peer for secureOrderer
# Set the context
# $1 = tls in case TLS need to be enabled
. bins/set-context.sh secureOrderer $1


# Submit the channel create tx
bins/submit-channel-create.sh

# Give time for the channel tx to propagate
sleep 3s

# Join secureOrderer peer to the channel
bins/join-channel.sh

sleep 3s

# Update anchor peer in channel
bins/anchor-update.sh

############################
# Setup anchor peer for secOrg
# Set the context
# $1 = tls in case TLS need to be enabled
. bins/set-context.sh secOrg $1

# Join the secOrg peer
bins/join-channel.sh

sleep 3s

# Update anchor peer in channel
bins/anchor-update.sh