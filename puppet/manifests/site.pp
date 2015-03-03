class { 'ldap::server::master':
  suffix      => 'dc=foo,dc=bar',
  rootpw      => '{SSHA}o55pAdS3VSTvfd1RPSIEnHM2MvBlQdOt',
}

class { 'ldap::client':
    uri  => 'ldap://localhost',
    base => 'dc=foo,dc=bar'
}

class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=foo,dc=bar',
  ldap_bind_id   => 'cn=admin,dc=foo,dc=bar',
  ldap_bind_pass => '{SSHA}o55pAdS3VSTvfd1RPSIEnHM2MvBlQdOt',
  require        => Class['ldap::server::master'],
}

include ldap, phpldapadmin
