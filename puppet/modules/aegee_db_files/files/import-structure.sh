#!/bin/sh

#finally import the structure (people, antennae and so on):
/usr/bin/ldapadd -x -D "cn=admin,dc=aegee,dc=org" -w aegee -f /var/opt/aegee/10-structure.ldif 
/usr/bin/ldapadd -x -D "cn=admin,dc=aegee,dc=org" -w aegee -f /var/opt/aegee/11-antennae.ldif 
/usr/bin/ldapadd -x -D "cn=admin,dc=aegee,dc=org" -w aegee -f /var/opt/aegee/12-users.ldif 
