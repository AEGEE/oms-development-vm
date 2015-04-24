#!/bin/sh

#finally import the structure (people, antennae and so on):
/usr/bin/ldapmodify -Q -c -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/10-structure.ldif
/usr/bin/ldapmodify -Q -c -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/11-antennae.ldif
/usr/bin/ldapmodify -Q -c -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/12-users.ldif

# Nop to have clean exit code
:
