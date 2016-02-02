#!/bin/bash

#removes the files inside the folders that are necessary 
#to host the repo  
rm /srv/oms-core/.delme
rm /srv/oms-profiles-module/.delme

#ignores the new files in the folders
echo -e $'\n*' >> /vagrant/ignore/.gitignore
