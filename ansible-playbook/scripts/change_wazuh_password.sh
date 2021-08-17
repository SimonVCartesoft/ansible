#!/bin/bash


cd /etc/filebeat/


# Get wazuh password
PASS=$(awk '/wazuh /{ print $3 }' /etc/elasticsearch/password.bkp)

# Change wazuh password
awk -e "/password: /{gsub(/: (\S+)/, \": $PASS\")} 1" filebeat.yml > filebeat.yml.tmp
mv filebeat.yml.tmp filebeat.yml