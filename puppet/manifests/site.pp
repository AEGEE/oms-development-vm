#Precondition: apt-get update

exec { "aptGetUpdate":
    command => "apt-get update",
    user => "root",
    path => ["/bin", "/usr/bin"],
    before => File['/var/opt/aegee'],
}

# Copy all DB files to node
file { "/var/opt/aegee":
  ensure => "directory",
  owner  => "root",
  group  => "root",
  mode   => 755,
  recurse => remote,
  source  => "puppet:///modules/aegee_db_files/",
}

# Run ldapadd to import some LDIF files
exec { "import log + indices":
  command => '/var/opt/aegee/import-log-indices.sh',
  user    => "root",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['o=aegee,c=eu'],
              ],
  before => Exec['translate aegee schema'],
}
exec { "translate aegee schema":
  command => '/var/opt/aegee/translate-ldif.sh',
  user    => "vagrant",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['o=aegee,c=eu'],
              ],
#  before => Exec['import schemas'],
}
exec { "import schemas":
  command => '/var/opt/aegee/import-schema.sh',
  user    => "root",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['o=aegee,c=eu'],
               Exec['translate aegee schema']
              ],
}
exec { "import ldif structure":
  command => '/var/opt/aegee/import-structure.sh',
  user    => "vagrant",
  require => Exec['import schemas'],
}

# Configure LDAP server
class { 'openldap::server': }
openldap::server::database { 'o=aegee,c=eu':
  rootdn => 'cn=admin,o=aegee,c=eu',
  rootpw => 'aegee',
  backend => hdb,
  ensure => present,
}

# Configure phpLDAPadmin (only for development)
class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'o=aegee,c=eu',
  ldap_bind_id   => 'cn=admin,o=aegee,c=eu',
  ldap_bind_pass => 'aegee', 
  require        => Openldap::Server::Database['o=aegee,c=eu'],
}->

#Overlays
#dynamic groups
openldap::server::module { 'dynlist':
  ensure => present,
}
->

##TODO: extend it to have custom attribute for dynlist
openldap::server::overlay { 'dynlist on o=aegee,c=eu':
  ensure => present,
}

include phpldapadmin, aegee_db_files #, nodejs
#include apt_update
include othertools
include nodejs
