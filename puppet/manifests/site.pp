
#Packages necessary to build a NPM module ("mongodriver")
  package { 'g++':
    ensure  => installed,
  }->
  package { 'libkrb5-dev':
    ensure  => installed,
  }


# Install Node.js and npm (already bundled)
  class { 'nodejs':
    version         => 'v4.1.2',
    make_install => false,
  }


  # Install 'forever' to run the nodejs process as daemon
  package { 'forever':
    ensure    => 'present',
    provider  => 'npm',
    require   => [ Class['nodejs'], Class['mongodb'], ],
  }
  

# Load OMS modules
#Core
aegee_oms_modules { 'oms-core':
  module_name   => 'oms-core',
  root_path          => '/srv/oms-core',
  git_source         => 'https://github.com/AEGEE/oms-core.git',
  git_branch         => 'dev',
  require              => [ Package['forever'], Package['libkrb5-dev'], Class['mongodb'], ],
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
  dbname                     => 'o=aegee,c=eu',
  rootdn                       => 'cn=admin,o=aegee,c=eu',
  rootpw                       => 'aegee',
  import_testdata         => true,
  install_phpldapadmin => true, #vhost is broken in localhost
  ldap_loglvel                => 'stats',
}

#Add postgresql backend
aegee_postgre{ 'aegee_postgre':
  install_phppgadmin  => true, #WARNING: any password will log in as of now
  require                    => Class['mongodb'],
}

#Add mongodb backend
include apt
class { 'mongodb':
  package_name     => 'mongodb-org',
  package_ensure   => '3.2.4',
  logdir                   => '/var/log/mongodb/',
  # only debian like distros
  old_servicename  => 'mongod',
  require                 => Class['nodejs'],
}
##check how useful is the below, otherwise just delete it
#mongodb::mongod {'my_mongod_instance1':
#    mongod_instance    => 'mongodb1',
#    mongod_add_options => ['slowms = 50'],
#    mongod_port => 27018,
#    require => Class['mongodb'],
#}
# DBs and users will be set by the application

#sometimes it isn't running?! but class mongo should make it run
#and i can't redeclare because then puppet complains
#service { 'mongodb up':
#    name => 'mongod',
#    ensure   => running,
#    provider => 'upstart',
#    require => Class['mongodb'],
#}

class { 'apache':
        mpm_module      => 'prefork',
        require               => [ Class['openldap::server'], Class['postgresql::server'], ],
    }
class { 'apache::mod::php': }

class { 'redis::install':
    redis_version     => '2:2.8.4-2',
    redis_package  => true,
}

##same problem as mongo
#service { 'redis up':
#    name => 'redis-server',
#    ensure   => running,
#    provider => 'upstart',
#    require => Class['redis::install'],
#}

include git