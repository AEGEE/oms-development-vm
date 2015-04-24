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
}
exec { "import schemas":
  command => '/var/opt/aegee/import-schema.sh',
  user    => "root",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['dc=aegee,dc=org'],
              ],
}
exec { "import ldif structure":
  command => '/var/opt/aegee/import-structure.sh',
  user    => "root",
  require => Exec['import schemas'],
}

# Configure LDAP server
class { 'openldap::server': }
openldap::server::database { 'dc=aegee,dc=org':
  rootdn => 'cn=admin,dc=aegee,dc=org',
  rootpw => 'aegee',
  ensure => present,
}

# Configure phpLDAPadmin (only for development)
class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=aegee,dc=org',
  ldap_bind_id   => 'cn=admin,dc=aegee,dc=org',
  ldap_bind_pass => 'aegee', # TODO: not sure what this means
  require        => Openldap::Server::Database['dc=aegee,dc=org'],
}

# Random modification with ldapdn to test the module
ldapdn{"random modification to test ldapdn":
  dn => "dc=aegee,dc=org",
  attributes => [
      "dc: aegee",
      "description: AEGEE rocks!",
      "objectClass: dcObject",
      "objectClass: organization",
      "o: AEGEE-Europe",
    ],
  unique_attributes => ["o","dc","description"],
  require => Openldap::Server::Database['dc=aegee,dc=org'],
  ensure => present,
}
