#!/bin/bash
#Cleans up the specified volume

# $1 = volume to be deleted

# acloudfan_data-orderer.secureOrderer.com
# acloudfan_data-peer1.secureOrderer.com
# acloudfan_data-peer1.secOrg.com

# use command to verify if volume is deleted
# docker volume list

docker volume rm  $1

echo "Done."
