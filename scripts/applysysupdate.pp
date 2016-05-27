class { 'redis::install':
    redis_version     => '2:2.8.4-2',
    redis_package  => true,
  }

  service { 'redis-server':
    name => 'redis-server',
    ensure   => running,
    provider => 'upstart',
    require => Class['redis::install'],
}