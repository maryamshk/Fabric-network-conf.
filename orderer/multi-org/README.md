# Test Configs
# There are multiple config files available under the folder setup/config/multi-org
# These files will be used for demonstrating the concepts, recipes and exercices
# Refer to the videos for use of specific policies

=======================
# Script: block-json.sh
=======================
# Extract Application group
./block-json.sh application 
# Extract Orderer group
./block-json.sh orderer 
# Extract application channel_group
./block-json.sh channel_group
 # Extract Channel policies
./block-json.sh channel_group policies
# Extract Application policies
./block-json.sh  channel_group groups.Application.policies
# Extract Application - ACLs & Policies
./block-json.sh acls


======================
# Common launch error
======================
2019-02-09 15:03:05.535 UTC [orderer.common.server] Main -> ERRO 001 failed to parse config:  Error reading configuration: Unsupported Config Type ""

Happens because Fabric requires the FABRIC_CFG_PATH to be set.
To address the error:

export FABRIC_CFG_PATH=$PWD
orderer

=================
# Multi Org Setup
=================
Org#1   Orderer org - dedicated org for the Orderer service
Org#2   secureOrderer Airlines
Org#3   secOrg Airlines

======================
# To Setup the Orderer
======================
Execute the ./init.sh
- Cleans the file system
- Generates the crypto materal. Uses setup/config/multi-org/crypto-config.yaml
- Generates the Genesis block and the create channel transaction

export FABRIC_CFG_PATH=$PWD
Orderer
*OR*
You may use the script ./launch.sh

