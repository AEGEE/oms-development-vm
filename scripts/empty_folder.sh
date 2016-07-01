#!/bin/bash

FOLDERS[0]="/srv/oms-core/"
FOLDERS[1]="/srv/oms-cron/"
FOLDERS[2]="/srv/oms-profiles-module/"
FOLDERS[3]="/srv/oms-events/"
FOLDERS[4]="/srv/oms-token-master/"

#removes the files inside the folders that are necessary 
#to host the repo  
for i in “${FOLDERS[@]}”
do
	if [ -e $i.delme ]; then
		rm $i.delme
	fi
	
	if [ -e $i.gitkeep ]; then
		rm $i.gitkeep
	fi
done 


#ignores the new files in the folders
echo -e $'\n*' >> /vagrant/ignore/.gitignore
