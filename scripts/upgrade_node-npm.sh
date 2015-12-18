#!/bin/bash

#Upgrade node from npm
#which npm > /vagrant/whichone
npm cache clean -f
npm install -g n
n 4.1.2

#Upgrade npm
npm install -g npm@2.14.15
