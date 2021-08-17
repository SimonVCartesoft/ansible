#!/bin/bash


export JAVA_HOME=/usr/share/elasticsearch/jdk/


# Generate a random password on 20 chars
PASS=$(pwgen -1 -s 20)

# Hash this password with the elastic script
HASH=$(bash /usr/share/elasticsearch/plugins/opendistro_security/tools/hash.sh -p $PASS)

# Place the hash on the internal_users_tmp file
awk -e "/$1:/,/hash:/{gsub(/\"(\S+)/, \"'$HASH\'\")} 1" /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/internal_users.yml > /tmp/$1.todel

# Replace the hash on the internal_users file
cp -f /tmp/$1.todel /usr/share/elasticsearch/plugins/opendistro_security/securityconfig/internal_users.yml

# Backup user and password on a file
if [[ $(awk "/$1/{ print $3 }" /etc/elasticsearch/password.bkp) ]]; then
    awk -e "/$1 : /{sub(/: (\S+)/, \": $PASS\")} 1" /etc/elasticsearch/password.bkp > /etc/elasticsearch/password.bkp.tmp
    mv /etc/elasticsearch/password.bkp.tmp > /etc/elasticsearch/password.bkp
else
    echo $1 : $PASS >> /etc/elasticsearch/password.bkp
fi

# Clean tmp file
rm -rf /tmp/$1.todel