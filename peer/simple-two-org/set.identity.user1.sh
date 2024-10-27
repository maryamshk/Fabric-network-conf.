# The env.sh file sets the identity to Peer
# This will set the identity to Admin 

export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/peerOrganizations/secureOrderer.com/users/User1@secureOrderer.com/msp
#export CORE_PEER_MSPCONFIGPATH=$CONFIG_DIRECTORY/crypto-config/ordererOrganizations/secureOrderer.com/users/Admin@secureOrderer.com/msp
echo ' Switched identity to User1 !!!'
