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
  before => Exec['translate aegee schema'],
}
exec { "translate aegee schema":
  command => '/var/opt/aegee/translate-ldif.sh',
  user    => "vagrant",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['o=aegee,c=eu'],
              ],
#  before => Exec['import schemas'],
}
exec { "import schemas":
  command => '/var/opt/aegee/import-schema.sh',
  user    => "root",
  require => [ File['/var/opt/aegee'],
               Openldap::Server::Database['o=aegee,c=eu'],
               Exec['translate aegee schema']
              ],
}
exec { "import ldif structure":
  command => '/var/opt/aegee/import-structure.sh',
  user    => "vagrant",
  require => Exec['import schemas'],
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
}->

#Overlays
#dynamic groups
openldap::server::module { 'dynlist':
  ensure => present,
}
->

##TODO: extend it to have custom attribute for dynlist
openldap::server::overlay { 'dynlist on o=aegee,c=eu':
  ensure => present,
}

# Install Node.js and npm
# See https://github.com/puppet-community/puppet-nodejs
class { 'nodejs':
  # TODO: The following setting installs nodejs from apt, which is not very
  #       recent. However, installing from NodeSource currently fails due to a
  #       bug in puppet-nodejs. See
  #       https://github.com/puppet-community/puppet-nodejs/issues/149
  #       Try to update puppet-nodejs once the bug is fixed.
  manage_package_repo       => false,
  nodejs_dev_package_ensure => 'present',
  npm_package_ensure        => 'present',
  legacy_debian_symlinks    => true,
}

# Clone OMS-core from git
file { '/srv/oms-core':
  ensure => directory,
}
->
vcsrepo { '/srv/oms-core':
  ensure   => present,
  provider => git,
  source   => 'https://bitbucket.org/aegeeitc/oms-core.git',
}

# Install OMS-core dependencies via npm
# See http://howtonode.org/managing-module-dependencies and
# https://docs.npmjs.com/cli/install
# TODO: It would be great if there was a proper "puppet way" to do this.
#       A feature request is tracked here:
#       https://github.com/puppet-community/puppet-nodejs/issues/154
exec { 'install dependencies of oms-core':
  command => '/usr/bin/npm install',
  cwd     => '/srv/oms-core',
  require => [ Class['nodejs'], Vcsrepo['/srv/oms-core'] ],
}

# Start OMS-core as an upstart service
service { 'oms-core':
  ensure   => running,
  provider => 'upstart',
  require  => [ Package['forever'],
                File['/etc/init/oms-core.conf'],
		Exec['install dependencies of oms-core'] ],
}

package { 'forever':
  ensure   => 'present',
  provider => 'npm',
}

# TODO: this should rather be provided by oms-core.git, so puppet would either
#       create a link or copy the file to /etc/init/. At the very least, this
#       file should not be with the other DB files.
file { '/etc/init/oms-core.conf':
  source => 'puppet:///modules/aegee_db_files/oms-core.conf',
}

include phpldapadmin, git
include aegee_db_files, othertools
