#!/bin/sh

/usr/bin/ldapmodify -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/1-log.ldif
/usr/bin/ldapmodify -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/2-indices.ldif
