# Installs and configures the (AEGEE-Europe) OMS modules 
define aegee_oms_modules(
    $module_name,
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
  ::nodejs::npm { "npm-install-dir of ${module_name}":
  list         => true, # flag to tell puppet to execute the package.json file
  directory    => $root_path,
  exec_as_user => 'vagrant',
#  install_opt  => '-x -y -z',
  require => [
 #                Exec['Update node and npm'],
                  Vcsrepo[$root_path],
                ],
}->

  # Start OMS module as an upstart service: set configuration
  file { "/etc/init/${module_name}.conf":
    source => "puppet:///modules/aegee_oms_modules/etc/init/${module_name}.conf",
  }
  
##FIXME: below is commented because core fails to start for unknown reasons (starts ok manually)
  #Start service
#  service { $module_name:
#    ensure   => running,
#    provider => 'upstart',
#    require  => [
#                  File["/etc/init/${module_name}.conf"],
#                  Package['forever'],
#         #         Exec["install dependencies of module ${module_name}"],
#                ],
#  }

}


include git
