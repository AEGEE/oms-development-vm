sudo rm /var/opt/aegee/testdata/.dataimported
sudo puppet apply --modulepath=/vagrant/puppet/modules /vagrant/scripts/updateschema.pp