
#Packages necessary to build a NPM module ("mongodriver")
  package { 'g++':
    ensure  => installed,
  }->
  package { 'libkrb5-dev':
    ensure  => installed,
  }->


# Install Node.js and npm
  # See https://github.com/puppet-community/puppet-nodejs
  class { 'nodejs': } ->

  #Update node and npm to latest version......
  #the above doesn't do a great job
  exec { 'Update node and npm':
    command => '/vagrant/scripts/upgrade_node-npm.sh',
  }
  ->

  # Install 'forever' to run the nodejs process as daemon
  package { 'forever':
    ensure   => 'present',
    provider => 'npm',
  }
  ->

# Load OMS modules
#Core
aegee_oms_modules { 'oms-core':
  module_name => 'oms-core',
  root_path   => '/srv/oms-core',
  git_source  => 'https://github.com/AEGEE/oms-core.git',
  git_branch  => 'dev',
}
->
#Profile
aegee_oms_modules { 'oms-profiles-module':
  module_name => 'oms-profiles-module',
  root_path   => '/srv/oms-profiles-module',
  git_source  => 'https://github.com/AEGEE/oms-profiles-module.git',
  git_branch  => 'dev',
}
->

#After cloning (at least the core), set up LDAP 
aegee_ldap { 'aegee_ldap':
  dbname               => 'o=aegee,c=eu',
  rootdn               => 'cn=admin,o=aegee,c=eu',
  rootpw               => 'aegee',
  import_testdata      => true,
  install_phpldapadmin => true,
  ldap_loglvel         => 'stats',
}

#Add mongodb backend
#class { 'mongodb':
#  package_name  => 'mongodb-org',
#  logdir       => '/var/log/mongodb/',
#  # only debian like distros
#  old_servicename => 'mongod'
#}
#mongodb::mongod {'my_mongod_instance1':
#    mongod_instance    => 'mongodb1',
#    mongod_add_options => ['slowms = 50'],
#    mongod_port => 27018,
#    require => Class['mongodb'];
#}
# DBs and users will be set by the application

#Add postgresql backend
class { 'postgresql::server': }



include git
