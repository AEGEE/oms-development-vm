# -*- mode: ruby -*-
# vi: set ft=ruby :

# If you want to use this on a Windows host, you probably want to look at this:
#  * http://stackoverflow.com/questions/5917249/git-symlinks-in-windows
#  * https://help.github.com/articles/dealing-with-line-endings/

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "aegee-virtual"
  config.vm.network "forwarded_port", guest: 80, host: 8888
  config.vm.network "forwarded_port", guest: 389, host: 4444
  config.vm.network "forwarded_port", guest: 8080, host: 8800

  config.vm.network :forwarded_port, guest: 22, host: 2222, host_ip: "0.0.0.0", id: "ssh", auto_correct: true

  # config.vm.provider "virtualbox" do |vb|
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end

  #served folder
  config.vm.synced_folder "serve", "/var/www/html"
  #config.vm.synced_folder "oms-core", "/srv/oms-core"

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
  end
end
