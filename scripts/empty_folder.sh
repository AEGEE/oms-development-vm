#!/bin/bash

folders=("/srv/oms-cron/" "/srv/oms-core/" "/srv/oms-profiles-module/" "/srv/oms-events/" "/srv/oms-token-master/")

#removes the files inside the folders that are necessary 
#to host the repo  
for ix in ${!folders[*]}
do
	cd /srv/
	cd ${folders[$ix]}
	rm .delme
	rm .gitkeep
done 


#ignores the new files in the folders
echo -e $'\n*' >> /vagrant/ignore/.gitignore
