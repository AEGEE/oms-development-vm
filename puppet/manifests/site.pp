class { 'ldap::server::master':
  suffix      => 'dc=foo,dc=bar',
  rootpw      => '{SHA}iEPX+SQWIR3p67lj/0zigSWTKHg=',
}

class { 'ldap::client':
    uri  => 'ldap://localhost',
    base => 'dc=foo,dc=bar'
}

include ldap