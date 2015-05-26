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
               Openldap::Server::Database['dc=aegee,dc=org'],
              ],
  before => Exec['translate aegee schema'],
}
exec { "translate aegee schema":
  command => '/var/opt/aegee/translate-ldif.sh',
  user    => "vagrant",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['dc=aegee,dc=org'],
              ],
#  before => Exec['import schemas'],
}
exec { "import schemas":
  command => '/var/opt/aegee/import-schema.sh',
  user    => "root",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['dc=aegee,dc=org'],
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
openldap::server::database { 'dc=aegee,dc=org':
  rootdn => 'cn=admin,dc=aegee,dc=org',
  rootpw => 'aegee',
  backend => hdb,
  ensure => present,
}

# Configure phpLDAPadmin (only for development)
class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=aegee,dc=org',
  ldap_bind_id   => 'cn=admin,dc=aegee,dc=org',
  ldap_bind_pass => 'aegee', 
  require        => Openldap::Server::Database['dc=aegee,dc=org'],
}->

#Overlays
#dynamic groups
openldap::server::module { 'dynlist':
  ensure => present,
}
->

##TODO: extend it to have custom attribute for dynlist
openldap::server::overlay { 'dynlist on dc=aegee,dc=org':
  ensure => present,
}

include phpldapadmin, aegee_db_files
