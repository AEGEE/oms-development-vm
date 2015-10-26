class aegee_oms_core(
    $root_path,
    $git_source,
    $git_branch = 'master',
  ) {

  # Clone OMS-core from git
  file { $root_path:
    ensure => directory,
  }
  ->
  vcsrepo { $root_path:
    ensure   => present,
    provider => git,
    source   => $git_source,
    revision => $git_branch,
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

  # Install OMS-core dependencies via npm
  # See http://howtonode.org/managing-module-dependencies and
  # https://docs.npmjs.com/cli/install
  # TODO: It would be great if there was a proper "puppet way" to do this.
  #       A feature request is tracked here:
  #       https://github.com/puppet-community/puppet-nodejs/issues/154
  exec { 'install dependencies of oms-core':
    command => '/usr/bin/npm install',
    cwd     => $root_path,
    require => [
                  Class['nodejs'],
                  Vcsrepo[$root_path],
                ],
  }

  # Install 'forever' to run the nodejs process as daemon
  package { 'forever':
    ensure   => 'present',
    provider => 'npm',
  }

  # Start OMS-core as an upstart service
  file { '/etc/init/oms-core.conf':
    source => 'puppet:///modules/aegee_oms_core/etc/init/oms-core.conf',
  }
  ->
  service { 'oms-core':
    ensure   => running,
    provider => 'upstart',
    require  => [
                  Package['forever'],
                  Exec['install dependencies of oms-core'],
                ],
  }

}

include git
