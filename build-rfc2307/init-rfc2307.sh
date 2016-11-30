#!/bin/sh
#set -e
set -x

sleep 5


ldapadd  -ZZ -x -h ldap-rfc2307 -D "cn=admin,dc=apache,dc=org" -w admin -f /knox/conf/users-rfc2307.ldif



systemctl start sssd.service

function stop_running () {
	systemctl stop-running
	exit
}

trap exit TERM
trap stop_running EXIT

export TERM=dumb

systemctl status sssd.service

# Start knox
java -jar knox/knox-0.10.0/bin/gateway.jar

while true ; do sleep 1000 & wait $! ; done