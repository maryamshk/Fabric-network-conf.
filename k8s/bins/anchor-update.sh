#!/bin/sh

peer channel update -f ../config/secureOrderer-peer-update.tx -c airlinechannel -o $ORDERER_ADDRESS

