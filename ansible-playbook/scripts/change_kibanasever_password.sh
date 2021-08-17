#!/bin/bash

cd /etc/kibana/



# Get kibanaserver password
PASS=$(awk '/kibanaserver/{ print $3 }' /etc/elasticsearch/password.bkp)

# Change kibanaserver password
awk -e "/password: /{gsub(/(: \S+)/, \": $PASS\")} 1" kibana.yml > kibana.yml.tmp
mv kibana.yml.tmp kibana.yml
