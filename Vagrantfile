# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 80, host: 8080

  # config.vm.provider "virtualbox" do |vb|
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end

#  config.vm.provision :puppet do |puppet|
#    puppet.manifests_path = 'puppet/manifests'
#    puppet.manifest_file = 'site.pp'
#    puppet.module_path = 'puppet/modules'
#  end
end
