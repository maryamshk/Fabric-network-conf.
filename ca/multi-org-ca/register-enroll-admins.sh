#!/bin/bash
# Registers the 3 admins
# secureOrderer-admin, secOrg-admin, orderer-admin

# Registers the admins
function registerAdmins {
    # 1. Set the CA Server Admin as FABRIC_CA_CLIENT_HOME
    source setclient.sh   caserver   admin

    # 2. Register secureOrderer-admin
    echo "Registering: secureOrderer-admin"
    ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
    fabric-ca-client register --id.type client --id.name secureOrderer-admin --id.secret pw --id.affiliation secureOrderer --id.attrs $ATTRIBUTES

    # 3. Register secOrg-admin
    echo "Registering: secOrg-admin"
    ATTRIBUTES='"hf.Registrar.Roles=peer,user,client","hf.AffiliationMgr=true","hf.Revoker=true"'
    fabric-ca-client register --id.type client --id.name secOrg-admin --id.secret pw --id.affiliation secOrg --id.attrs $ATTRIBUTES

    # 4. Register orderer-admin
    echo "Registering: orderer-admin"
    ATTRIBUTES='"hf.Registrar.Roles=orderer"'
    fabric-ca-client register --id.type client --id.name orderer-admin --id.secret pw --id.affiliation orderer --id.attrs $ATTRIBUTES
}

# Setup MSP
function setupMSP {
    mkdir -p $FABRIC_CA_CLIENT_HOME/msp/admincerts

    echo "====> $FABRIC_CA_CLIENT_HOME/msp/admincerts"
    cp $FABRIC_CA_CLIENT_HOME/../../caserver/admin/msp/signcerts/*  $FABRIC_CA_CLIENT_HOME/msp/admincerts
}

# Enroll admin
function enrollAdmins {
    # 1. secureOrderer-admin
    echo "Enrolling: secureOrderer-admin"

    ORG_NAME="secureOrderer"
    source setclient.sh   $ORG_NAME   admin
    checkCopyYAML
    fabric-ca-client enroll -u http://secureOrderer-admin:pw@localhost:7054

    setupMSP

    # 2. secOrg-admin
    echo "Enrolling: secOrg-admin"

    ORG_NAME="secOrg"
    source setclient.sh   $ORG_NAME   admin
    checkCopyYAML
    fabric-ca-client enroll -u http://secOrg-admin:pw@localhost:7054

    setupMSP

    # 3. orderer-admin
    echo "Enrolling: orderer-admin"

    ORG_NAME="orderer"
    source setclient.sh   $ORG_NAME   admin
    checkCopyYAML
    fabric-ca-client enroll -u http://orderer-admin:pw@localhost:7054

    setupMSP
}

# If client YAML not found then copy the client YAML before enrolling
# YAML picked from setup/config/multi-org-ca/yaml.0/ORG-Name/*
function    checkCopyYAML {
    SETUP_CONFIG_CLIENT_YAML="../../setup/config/multi-org-ca/yaml.0"
    if [ -f "$FABRIC_CA_CLIENT_HOME/fabric-ca-client.yaml" ]
    then 
        echo "Using the existing Client Yaml for $ORG_NAME  admin"
    else
        echo "Copied the Client Yaml from $SETUP_CONFIG_CLIENT_YAML/$ORG_NAME "
        mkdir -p $FABRIC_CA_CLIENT_HOME
        cp  "$SETUP_CONFIG_CLIENT_YAML/$ORG_NAME/fabric-ca-client-config.yaml" "$FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml"
    fi
}

echo "========= Registering ==============="
registerAdmins
echo "========= Enrolling ==============="
enrollAdmins
echo "==================================="