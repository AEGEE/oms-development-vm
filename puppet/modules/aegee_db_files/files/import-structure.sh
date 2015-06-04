#!/bin/sh

#finally import the structure (people, antennae and so on):
/usr/bin/ldapadd -x -D "cn=admin,o=aegee,c=eu" -w aegee -f /var/opt/aegee/10-structure.ldif -c 
/usr/bin/ldapadd -x -D "cn=admin,o=aegee,c=eu" -w aegee -f /var/opt/aegee/11-antennae.ldif -c 
/usr/bin/ldapadd -x -D "cn=admin,o=aegee,c=eu" -w aegee -f /var/opt/aegee/12-users.ldif -c 
/usr/bin/ldapadd -x -D "cn=admin,o=aegee,c=eu" -w aegee -f /var/opt/aegee/13-committees.ldif -c 
/usr/bin/ldapadd -x -D "cn=admin,o=aegee,c=eu" -w aegee -f /var/opt/aegee/14-commissions.ldif -c 
/usr/bin/ldapadd -x -D "cn=admin,o=aegee,c=eu" -w aegee -f /var/opt/aegee/15-externals.ldif -c 

/usr/bin/ldapadd -x -D "cn=admin,o=aegee,c=eu" -w aegee -f /var/opt/aegee/30-experimental.ldif -c 

