# -*- mode: ruby -*-
# vi: set ft=ruby :

# If you want to use this on a Windows host, you probably want to look at this:
#  * http://stackoverflow.com/questions/5917249/git-symlinks-in-windows
#  * https://help.github.com/articles/dealing-with-line-endings/

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "aegee-virtual.nowhere.nodomain"

  #HTTP port (apache2)
  config.vm.network "forwarded_port", guest: 80, host: 8888
  #LDAP standard port (slapd)
  config.vm.network "forwarded_port", guest: 389, host: 4444
  #SSH from anywhere on the network (sshd)
  config.vm.network :forwarded_port, guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true
  
  #API port (oms-core)
  config.vm.network "forwarded_port", guest: 8080, host: 8800
  #Profiles module port (generic nodejs app)
  config.vm.network "forwarded_port", guest: 8081, host: 8801

  config.vm.network "forwarded_port", guest: 8090, host: 8900
  #cron
  config.vm.network "forwarded_port", guest: 8091, host: 8901

  

  #Sharing the content of the VM directly so we can work from the host
  config.vm.synced_folder "ignore/oms-core",              "/srv/oms-core"
  config.vm.synced_folder "ignore/oms-profiles-module",   "/srv/oms-profiles-module"
  config.vm.synced_folder "ignore/oms-cron",              "/srv/oms-cron"
  config.vm.synced_folder "ignore/oms-token-master",   "/srv/oms-token-master"
  

  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
  end

  config.vm.provision :shell, :path => "scripts/upgrade_puppet.sh"
  config.vm.provision :shell, :path => "scripts/empty_folder.sh"
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
    puppet.options = "--hiera_config /vagrant/hiera.yaml" # add --verbose for more info and --debug for omgsomuch
  end

  #sometimes puppet does not start it and i cannot redeclare it in the manifest so here it is
  config.vm.provision :shell, :inline => "sudo service mongod start"
  config.vm.provision :shell, :inline => "sudo service redis-server start"

end
