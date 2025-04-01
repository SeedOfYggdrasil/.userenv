#!/bin/bash

# how2.sh ver 1.0
# Custom Helpfiles for Remembering Shit

how2(){
    local arg=$1
    if [ -z "$arg" ]; then
        echo "Usage: how2 <PACKAGE>"  
        return 1
    elif [ "$arg" == "tmux" ]; then
        printf 'TMUX:\n\ntmux new-session\n(c-b \")split-window -h\n(c-b %)split-window -v\nattach'
        return 0
    else
        echo "Unrecognized package"
        return 1
    fi
}



