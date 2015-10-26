# Run apt-get update before installing any packages
# See http://johnleach.co.uk/words/771/puppet-dependencies-and-run-stages
class { 'apt': }
Exec['apt_update'] -> Package <| |>

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
exec { "import log + indices":
  command => '/var/opt/aegee/import-log-indices.sh',
  user    => "root",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['o=aegee,c=eu'],
              ],
    before =>   Openldap::Server::Schema["AEGEE"], 
}->

##Import schemas in a smarter way
openldap::server::schema { 'AEGEE':
  ensure  => present,
  path    => '/var/opt/aegee/aegee.schema',
  require => [
                File['/var/opt/aegee'],
                Openldap::Server::Database['o=aegee,c=eu'],
             ],
}->

exec { "import ldif structure":
  command => '/var/opt/aegee/import-structure.sh',
  user    => "vagrant",
  require => Openldap::Server::Schema["AEGEE"],
}

# Configure LDAP server
class { 'openldap::server': }
openldap::server::database { 'o=aegee,c=eu':
  rootdn => 'cn=admin,o=aegee,c=eu',
  rootpw => 'aegee',
  backend => hdb,
  ensure => present,
}

# Configure phpLDAPadmin (only for development)
class { 'phpldapadmin':
  ldap_host      => 'localhost',
  ldap_suffix    => 'o=aegee,c=eu',
  ldap_bind_id   => 'cn=admin,o=aegee,c=eu',
  ldap_bind_pass => 'aegee', 
  require        => Openldap::Server::Database['o=aegee,c=eu'],
}

# Load OMS-core
class { 'aegee_oms_core':
  root_path  => '/srv/oms-core',
  git_source => 'https://bitbucket.org/aegeeitc/oms-core.git',
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
  source   => 'https://bitbucket.org/aegeeitc/oms-poc-modules.git',
}
->
composer::exec { 'oms-modules-install':
  cmd     => 'install',
  cwd     => '/var/www/html/oms-modules',
  require => Class['composer'],
}

include phpldapadmin, git
include aegee_db_files, othertools
