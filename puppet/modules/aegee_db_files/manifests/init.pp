class aegee_db_files {
}

class othertools {
}

#class mongodb {
#  class {'::mongodb::globals':
#    manage_package_repo => true,
#    bind_ip             => ["127.0.0.1"],
#  }->
#  class {'::mongodb::server':
#    port    => 27017,
#    verbose => true,
#    ensure  => "present"
#  }->
#  class {'::mongodb::client': }
#}
#
#class redis-cl {
#  class { 'redis': }
#}

class othertools {

    #for inline editing
    package { "vim-common":
        ensure => latest,
    }

    #useful for resource mgmt
    package { "htop":
        ensure => present,
    }

    #useful just for PoC in php...
    package { "php5-curl":
        ensure => present,
    }


}

#include apt_update
#include othertools
#include nodejs
#include mongodb
#include redis-cl
