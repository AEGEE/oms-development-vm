# Installs and configures a PostgreSQL server for the OMS of AEGEE-Europe
define aegee_postgre (
    $install_phppgadmin = false,
  ) {

  # Configure Postgre server
  class { 'postgresql::server': 
    ip_mask_deny_postgres_user => '0.0.0.0/32',
    ip_mask_allow_all_users    => '127.0.0.1/0',
    listen_addresses           => '*',
    #ipv4acls    => ['host all postgre 0.0.0.0/0 md5'],
    user => 'postgres',
    postgres_password  => 'aegee',
  }

  postgresql::server::db { 'user_permissions':
    user     => 'admin',
    password => postgresql_password('admin', 'aegee'),
  }

  # Configure phppgadmin
  if $install_phppgadmin {

  #access rights

    postgresql::server::pg_ident_rule{ 'needed for cli':
    map_name          => 'www-data',
    system_username   => 'postgres',
    database_username => 'postgres',
    order => '001',
  }
  postgresql::server::pg_ident_rule{ 'useful for phppgadmin- login as postgres':
    map_name          => 'www-data',
    system_username   => 'www-data',
    database_username => 'postgres',
    order => '002',
  }
  postgresql::server::pg_ident_rule{ 'useful for phppgadmin- login as admin':
    map_name          => 'www-data',
    system_username   => 'www-data',
    database_username => 'admin',
    order => '003',
  }
  
  postgresql::server::pg_hba_rule { 'allow local access to postgres':
    description => "Local access as postgres user",
    type        => 'local',
    database    => 'all',
    user        => 'all',
    auth_method => 'ident',
    auth_option => 'map=www-data',
    order => '000',
  }

    include phppgadmin

    #include ::apache
    
    apache::vhost { 'phppgadmin':
      servername => '127.0.0.1',
      docroot     => '/var/www/html',
      port        => 80,
      aliases     => [
        {
          alias => '/phpPgAdmin',
          path  => '/usr/share/phppgadmin'
        }, {
          alias => '/phppgadmin',
          path  => '/usr/share/phppgadmin'
        }
      ],
      priority => 20,
    } 
  }

}
