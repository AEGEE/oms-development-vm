class { 'ldap::server::master':
  suffix      => 'dc=foo,dc=bar',
  rootpw      => '{SHA}iEPX+SQWIR3p67lj/0zigSWTKHg=',
}

class { 'ldap::client':
    uri  => 'ldap://localhost',
    base => 'dc=foo,dc=bar'
}

class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'dc=foo,dc=bar',
  ldap_bind_id   => 'cn=root,dc=foo,dc=bar',
  ldap_bind_pass => '{SHA}iEPX+SQWIR3p67lj/0zigSWTKHg=',
  require        => Class['ldap::server::master'],
}

include ldap, phpldapadmin
