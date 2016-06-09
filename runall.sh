#!/bin/bash 

tmux new -d -s core
tmux new -d -s profiles
tmux new -d -s events

tmux send -t core "cd /srv/oms-profiles-module/lib && node server.js" ENTER 
tmux send -t profiles "cd /srv/oms-core/lib && node server.js" ENTER 
tmux send -t events "cd /srv/oms-events && gulp" ENTER 
