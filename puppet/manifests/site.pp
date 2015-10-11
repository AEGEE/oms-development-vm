# Run apt-get update before installing any packages
# See http://johnleach.co.uk/words/771/puppet-dependencies-and-run-stages
class { 'apt': }
Exec['apt_update'] -> Package <| |>

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
  source => 'puppet:///modules/aegee_ldap/oms-core.conf',
}

# Install some handy tools for development
#for inline editing
package { "vim-common":
  ensure => latest,
}

#useful most of the time
package { "curl":
  ensure => present,
}

#useful for resource mgmt
package { "htop":
  ensure => present,
}

#useful just for PoC in php...
package { "php5-curl":
  ensure => present,
}

include git
include aegee_ldap
