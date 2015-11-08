# Run apt-get update before installing any packages
# See http://johnleach.co.uk/words/771/puppet-dependencies-and-run-stages
class { 'apt': }
Exec['apt_update'] -> Package <| |>

class { 'aegee_ldap':
  dbname               => 'o=aegee,c=eu',
  rootdn               => 'cn=admin,o=aegee,c=eu',
  rootpw               => 'aegee',
  import_testdata      => true,
  install_phpldapadmin => true,
  ldap_loglvel         => 'stats',
}

# Load OMS-core
class { 'aegee_oms_core':
  root_path  => '/srv/oms-core',
  git_source => 'https://github.com/AEGEE/oms-core.git',
  require    => Openldap::Server::Database['o=aegee,c=eu'],
}

class { 'composer':
  suhosin_enabled => false,
}

# Clone OMS-modules from git and install dependencies
file { [ '/var/www', '/var/www/html', '/var/www/html/oms-modules' ]:
  ensure => directory,
}
->
vcsrepo { '/var/www/html/oms-modules':
  ensure   => present,
  provider => git,
  source   => 'https://github.com/AEGEE/oms-poc-modules.git',
}
->
composer::exec { 'oms-modules-install':
  cmd     => 'install',
  cwd     => '/var/www/html/oms-modules',
  require => Class['composer'],
}

include git
