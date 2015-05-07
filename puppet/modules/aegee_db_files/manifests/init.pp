class aegee_db_files {

# Random modification with ldapdn to test the module
ldapdn{"random modification to test ldapdn":
  dn => "dc=aegee,dc=org",
  attributes => [
      "dc: aegee",
      "description: AEGEE is the largest multidisciplinary student association in Europe",
      "objectClass: dcObject",
      "objectClass: organization",
      "o: AEGEE-Europe",
    ],
  unique_attributes => ["o","dc","description"],
  require => Openldap::Server::Database['dc=aegee,dc=org'],
  ensure => present,
}

$organisationalunits = ['antennae', 'commissions', 'people', 'committees', 'groups']

# Random modification with ldapdn to test the module
ldapdn{"other modification to test ldapdn":
  dn => "ou=${organisationalunits},dc=aegee,dc=org",
  attributes => [
      "ou: ${organisationalunits}",
      "description: All ${organisationalunits} in the organisation",
      "objectClass: organizationalUnit",
    ],
  unique_attributes => ["ou","description"],
  require => Ldapdn['random modification to test ldapdn'],
  ensure => present,
}

}