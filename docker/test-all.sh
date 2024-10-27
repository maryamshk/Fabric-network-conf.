#!/bin/bash
# Runs the test to validate the environment
# Usage:  ./test-all.sh [tls]
# If the $1 = "tls" then Orderer and Peers are launched with TLS enabled
# ENV must be up before this script is used

SLEEP_TIME=3s

echo "1....... As secureOrderer install the chaincode ....."
. ./bins/set-context.sh   secureOrderer   $1

./bins/cc-test.sh install

echo "2....... As secureOrderer instantiate the chaincode ....."
./bins/cc-test.sh instantiate

sleep $SLEEP_TIME

echo "3....... Query the chaincode ......"
./bins/cc-test.sh   query

echo "4....... As secOrg install the chaincode ......"
. ./bins/set-context.sh   secOrg   $1
./bins/cc-test.sh  install

echo "5....... Invoke the chaincode ......"
./bins/cc-test.sh   invoke

sleep $SLEEP_TIME

echo "6....... As secOrg Query the chaincode ......"
./bins/cc-test.sh   query

echo "7....... As secureOrderer Query the chaincode ......"
. ./bins/set-context.sh   secureOrderer   $1
./bins/cc-test.sh   query

echo "All tests completed"