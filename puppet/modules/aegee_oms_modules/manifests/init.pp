# Installs and configures the (AEGEE-Europe) OMS modules 
define aegee_oms_modules(
    $module_name = 'oms-core',
    $root_path,
    $git_source,
    $git_branch = 'master',
  ) {

  # Clone OMS module from git
  file { $root_path:
    ensure => directory,
  }
  ->
  vcsrepo { $root_path:
    ensure   => latest,
    provider => git,
    source   => $git_source,
    revision => $git_branch,
  }

    
  # Install OMS module dependencies via npm
  # See http://howtonode.org/managing-module-dependencies and
  # https://docs.npmjs.com/cli/install
  # TODO: It would be great if there was a proper "puppet way" to do this.
  #       A feature request is tracked here:
  #       https://github.com/puppet-community/puppet-nodejs/issues/154
  exec { "install dependencies of module ${module_name}":
    command => '/usr/bin/npm install',
    cwd     => $root_path,
    require => [
                  Exec['Update node and npm'],
                  Vcsrepo[$root_path],
                ],
    timeout => 500,
  }
  
  # Start OMS module as an upstart service: set configuration
  file { "/etc/init/${module_name}.conf":
    source => "puppet:///modules/aegee_oms_modules/etc/init/${module_name}.conf",
  }
  
  #Start service
  service { $module_name:
    ensure   => running,
    provider => 'upstart',
    require  => [
                  File["/etc/init/${module_name}.conf"],
                  Package["forever"],
                  Exec["install dependencies of module ${module_name}"],
                ],
  }

}


include git
