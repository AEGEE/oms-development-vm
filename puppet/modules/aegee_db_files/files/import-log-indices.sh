#!/bin/sh

/usr/bin/ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/1-log.ldif -c

/usr/bin/ldapmodify -Q -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/2-indices.ldif -c

# Nop to have clean exit code
:
