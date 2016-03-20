#!/bin/sh
# --verbose --debug
sudo puppet apply --modulepath=/vagrant/puppet/modules /vagrant/scripts/applysysupdate.pp --graph

#create png graph with 
#dot -Tpng cycles.dot -o /tmp/configuration.png