# Installs and configures an LDAP server for the OMS of AEGEE-Europe
define aegee_ldap (
    $dbname, $rootdn, $rootpw,
    $import_testdata = false,
    $install_phpldapadmin = false,
    $ldap_loglvel = 'none',
  ) {

  # Configure LDAP server
  class { 'openldap::server': }
  openldap::server::database { $dbname:
    ensure  => present,
    rootdn  => $rootdn,
    rootpw  => $rootpw,
    backend => hdb,
  }

  # Copy all DB files to node
  file { '/var/opt/aegee':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    recurse => remote,
    source  => '/srv/oms-core/schema',
  }

  # Import AEGEE schema and dependencies
  $standardLdapSchemas = ['core', 'cosine', 'dyngroup', 'inetorgperson', 'nis']
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
    ensure            => present,
    dn                => 'cn=config',
    attributes        => ["olcLogLevel: ${ldap_loglvel}"],
    unique_attributes => ['olcLogLevel'],
  }

  ldapdn { 'enable index':
    ensure            => present,
    dn                => 'olcDatabase={1}hdb,cn=config',
    attributes        => ['olcDbIndex: uid eq,pres,sub'],
    unique_attributes => ['olcDbIndex'],
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
    }->

    #include ::apache
    
    apache::vhost { 'phpldapadmin':
      servername => '127.0.0.1',
      docroot     => '/var/www/html',
      port        => 80,
      aliases     => [
        {
          alias => '/phpLDAPAdmin',
          path  => '/usr/share/phpldapadmin/htdocs/'
        }, {
          alias => '/phpldapadmin',
          path  => '/usr/share/phpldapadmin/htdocs/'
        }
      ],
    } 
  }

}
