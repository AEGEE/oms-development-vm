#!/bin/bash

#removes the files inside the folders that are necessary 
#to host the repo  
if [ -e /srv/oms-core/.delme ]; then
    rm /srv/oms-core/.delme
fi
if [ -e /srv/oms-profiles-module/.delme ]; then
    rm /srv/oms-profiles-module/.delme
fi

#ignores the new files in the folders
echo -e $'\n*' >> /vagrant/ignore/.gitignore
