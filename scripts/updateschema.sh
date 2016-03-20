sudo rm /var/opt/aegee/testdata/.dataimported
sudo apt-get purge slapd
sudo puppet apply --modulepath=/vagrant/puppet/modules /vagrant/scripts/updateschema.pp
