# Add aegee schema such that it can be included in slapd.conf
file { '/etc/ldap/schema/aegee.schema':
  ensure => file,
  mode   => 644,
  owner  => 'root',
  group  => 'root',
  source => 'puppet:///modules/aegee_db_files/aegee.schema',
  before => Class['ldap::server::master'],
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
#fabrizio's try (first does not work, second does)
exec { "import ldif files":
  command => '/var/opt/aegee/import-log-indices.sh',
  user    => "root",
  require => [ File['/var/opt/aegee'],
               Class['ldap::server::master'],
              ],
}
exec { "import ldif structure":
  command => '/var/opt/aegee/import-structure.sh',
  user    => "root",
  require => [ Exec['import ldif files'],
              ],
}


class { 'ldap::server::master':
  suffix      => 'dc=aegee,dc=org',
  rootpw      => '{SSHA}o55pAdS3VSTvfd1RPSIEnHM2MvBlQdOt',
  schema_inc  => [ 'aegee' ],
}

class { 'ldap::client':
  uri  => 'ldap://localhost',
  base => 'dc=aegee,dc=org'
}

class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=aegee,dc=org',
  ldap_bind_id   => 'cn=admin,dc=aegee,dc=org',
  ldap_bind_pass => 'aegee', # TODO: not sure what this means
  require        => Class['ldap::server::master'],
}

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
  require => Exec['import ldif files'],
  ensure => present,
  auth_opts => ["-xD", "cn=admin,dc=aegee,dc=org", "-w", "aegee"],
}

include ldap, phpldapadmin
