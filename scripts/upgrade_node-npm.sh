#!/bin/bash

#Upgrade node from npm
#which npm > /vagrant/whichone
npm cache clean -f
npm install -g n
n 4.1.2

#Upgrade npm
#npm install -g npm@2.14.15
#NOTE: the line above is commented because after all
# I think it is better to have the same version of
# node and npm as Travis-ci. This is achieved simply
# by upgrading node to 4.1.2
