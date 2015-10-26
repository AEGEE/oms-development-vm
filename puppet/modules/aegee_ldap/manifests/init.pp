class aegee_ldap (
    $dbname, $rootdn, $rootpw,
    $import_testdata = false,
    $install_phpldapadmin = false,
    $ldap_loglvel = 'none',
  ) {

  # Configure LDAP server
  class { 'openldap::server': }
  openldap::server::database { $dbname:
    rootdn  => $rootdn,
    rootpw  => $rootpw,
    backend => hdb,
    ensure  => present,
  }

  # Copy all DB files to node
  file { '/var/opt/aegee':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => remote,
    source  => 'puppet:///modules/aegee_ldap/',
  }

  # Import AEGEE schema and dependencies
  $standardLdapSchemas = [ 'core', 'cosine', 'dyngroup',
                           'inetorgperson', 'nis' ]
  openldap::server::schema { $standardLdapSchemas:
    ensure  => present,
  }
  openldap::server::schema { 'AEGEE':
    ensure  => present,
    path    => '/var/opt/aegee/aegee.schema',
    require => [
                  File['/var/opt/aegee'],
                  Openldap::Server::Database[$dbname],
                  Openldap::Server::Schema[$standardLdapSchemas],
               ],
  }

  # Basic LDAP configuration
  ldapdn { 'enable logging':
    dn                => 'cn=config',
    attributes        => ["olcLogLevel: ${ldap_loglvel}"],
    unique_attributes => ['olcLogLevel'],
    ensure            => present,
  }

  ldapdn { 'enable index':
    dn                => 'olcDatabase={1}hdb,cn=config',
    attributes        => ['olcDbIndex: uid eq,pres,sub'],
    unique_attributes => ['olcDbIndex'],
    ensure            => present,
    require           => Openldap::Server::Database[$dbname],
  }

  # Import test data (on first run)
  if $import_testdata {
    exec { 'import LDAP test data from LDIF files':
      command => "/var/opt/aegee/testdata/import-data.sh ${rootdn} ${rootpw}",
      creates => '/var/opt/aegee/testdata/.dataimported',
      unless  => '/usr/bin/test -f /var/opt/aegee/testdata/.dataimported',
      require =>  [
                    Openldap::Server::Database[$dbname],
                    Openldap::Server::Schema['AEGEE'],
                    File['/var/opt/aegee'],
                  ],
    }
  }

  # Configure phpLDAPadmin
  if $install_phpldapadmin {
    class { 'phpldapadmin':
      ldap_host      => 'localhost',
      ldap_suffix    => $dbname,
      ldap_bind_id   => $rootdn,
      ldap_bind_pass => $rootpw,
      require        => Openldap::Server::Database[$dbname],
    }
  }

}
