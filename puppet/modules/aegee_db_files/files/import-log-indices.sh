#!/bin/sh

#/usr/bin/ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/1-log.ldif

#/usr/bin/ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/2-indices.ldif


##This is commented because first you add the schema
##ldapadd -x -D 'cn=admin,dc=aegee,dc=org' -w admin -f structure.ldif
