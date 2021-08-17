#!/bin/bash

cd /etc/elasticsearch/



# Get admin subject
SUBJECT=$(openssl x509 -subject -nameopt RFC2253 -noout -in certs/admin.pem | awk '/subject/{ print $2 }')

# Change admin subject
awk -e "/admin_dn:/,/  - \"\S+\"/{gsub(/(CN=\S+)/, \"$SUBJECT\")} 1" elasticsearch.yml > elasticsearch.yml.tmp
mv elasticsearch.yml.tmp elasticsearch.yml
