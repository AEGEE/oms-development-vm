#!/bin/sh

/usr/bin/ldapadd -c -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/core.ldif
/usr/bin/ldapadd -c -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/cosine.ldif
/usr/bin/ldapadd -c -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/dyngroup.ldif
/usr/bin/ldapadd -c -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/inetorgperson.ldif
/usr/bin/ldapadd -c -Y EXTERNAL -H ldapi:/// -f /etc/ldap/schema/nis.ldif
/usr/bin/ldapadd -c -Y EXTERNAL -H ldapi:/// -f /var/opt/aegee/aegee.ldif

