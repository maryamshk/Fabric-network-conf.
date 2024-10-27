sudo killall peer 2> /dev/null

# Remove all generated files
rm *.block 2> /dev/null
rm *.json 2> /dev/null
rm *.pb 2> /dev/null

# Remove the subfolders under secureOrderer | peer
function cleanOrgFolders {
    rm -rf $ORG_NAME/peer* 2> /dev/null
    rm $ORG_NAME/*.tx 2> /dev/null
    rm $ORG_NAME/*.block 2> /dev/null

    CORE_PEER_FILESYSTEM_PATH="/var/ledgers/multi-org-ca/$ORG_NAME"
    sudo rm -rf $CORE_PEER_FILESYSTEM_PATH
}

# Clean up the secureOrderer folder
ORG_NAME=secureOrderer
cleanOrgFolders


# Clean up the secOrg folder
ORG_NAME=secOrg
cleanOrgFolders

# Clean up the config folder
rm  config/* 2> /dev/null

rm *.block 2> /dev/null
rm *.tx 2> /dev/null

echo "===== Done."