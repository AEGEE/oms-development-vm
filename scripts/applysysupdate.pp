#include mongodb

include apt

class { 'mongodb':
  package_name  => 'mongodb-org',
  package_ensure => '3.2.4',
  logdir       => '/var/log/mongodb/',
  # only debian like distros
  old_servicename => 'mongod'
}

#BELOW IS BROKEN
mongodb::mongod {'my_mongod_instance1':
    mongod_instance    => 'mongodb1',
    mongod_add_options => ['slowms = 50'],
    mongod_port => 27017,
    require => Class['mongodb']
}

# DBs and users will be set by the application