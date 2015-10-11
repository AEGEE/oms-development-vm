class aegee_ldap {

  # Copy all DB files to node
  file { "/var/opt/aegee":
    ensure => "directory",
    owner  => "root",
    group  => "root",
    mode   => 755,
    recurse => remote,
    source  => "puppet:///modules/aegee_ldap/",
  }

  # Basic LDAP configuration
  ldapdn { "enable logging":
    dn                => "cn=config",
    attributes        => ["olcLogLevel: stats"],
    unique_attributes => ["olcLogLevel"],
    ensure            => present,
  }

  ldapdn { "enable index":
    dn                => "olcDatabase={1}hdb,cn=config",
    attributes        => ["olcDbIndex: uid eq,pres,sub"],
    unique_attributes => ["olcDbIndex"],
    ensure            => present,
    require           => Openldap::Server::Database['o=aegee,c=eu'],
  }

  # Import AEGEE schema and dependencies
  $standardLdapSchemas = [ "core", "cosine", "dyngroup",
                           "inetorgperson", "nis" ]
  openldap::server::schema { $standardLdapSchemas:
    ensure  => present,
  }
  openldap::server::schema { 'AEGEE':
    ensure  => present,
    path    => '/var/opt/aegee/aegee.schema',
    require => [
                  File['/var/opt/aegee'],
                  Openldap::Server::Database['o=aegee,c=eu'],
                  Openldap::Server::Schema[$standardLdapSchemas],
               ],
  }

  # Import test data (on first run)
  exec { "import LDAP test data from LDIF files":
    command => '/var/opt/aegee/testdata/import-data.sh cn=admin,o=aegee,c=eu aegee',
    creates => '/var/opt/aegee/testdata/.dataimported',
    unless  => '/usr/bin/test -f /var/opt/aegee/testdata/.dataimported',
    require =>  [
                  Openldap::Server::Schema["AEGEE"],
                  File['/var/opt/aegee'],
                ],
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
  }

}
