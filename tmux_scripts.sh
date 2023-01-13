#!/bin/sh

# Set Session Name
SESSION="indrajeet_aio"
SESSIONEXISTS=$(tmux list-sessions | grep $SESSION)
FLAG=`docker ps | awk '$15=="indrajeet_aio" {print $15}' | wc -l`

if [ "$FLAG" == 0 ]
then
        make docker-run
fi

# Only create tmux session if it doesn't already exist
if [ "$SESSIONEXISTS" = "" ]
then
        # Start tmux server
        tmux start-server
        # Create a new tmux session
        tmux new-session -d -s $SESSION
        # Select first pane and open jupyter notebook
        tmux selectp -t 0
        tmux send-keys "make docker-resume" C-m
        #
        sleep 1s
        tmux splitw -h -p 50
        tmux selectp -t 1
        tmux send-keys "make docker-vscode" C-m
        # 
        sleep 1s
        tmux splitw -v -p 50
        tmux selectp -t 2
        tmux send-keys "make docker-shell" C-m
        #
        sleep 1s
        tmux selectp -t 0
        tmux splitw -v -p 50
fi

# Attach Session, on the Main window
tmux attach-session -t $SESSION:0
