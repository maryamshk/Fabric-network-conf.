# Cleans up the files generated during runs
killall peer  2> /dev/null

rm *.block   2> /dev/null
rm ./secureOrderer/*.block   2> /dev/null
rm ./secOrg/*.block  2> /dev/null

rm ./secureOrderer/*.log  2> /dev/null
rm ./secOrg/*.log  2> /dev/null

rm -rf /home/vagrant/ledgers/peer/multi-org/secureOrderer/*   2> /dev/null
rm -rf /home/vagrant/ledgers/peer/multi-org/secOrg/*  2> /dev/null