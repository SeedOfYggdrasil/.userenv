#!/bin/bash

err() {
    local msg=${1:-'Failed'}
    local e=${2:-'1'}    

    echo -e "${bold_red}Error${nc}: ${msg}"
    return $e
}

codespace() {
    label=sturdy-winner
    
    if ! command gh --version &>/dev/null; then
        err "Github ClI is not installed." 2
        return 2   
    fi

    gh codespace edit -d $label

    if [ $? -ne 0 ]; then
        err "Could not connect to codespace." 3
        return 3
    fi

    gh codespace ssh -d $label 

    if [ $? -ne 0 ]; then
        err "Could not connect to codespace." 3
        return 3
    fi   

    return 0
}


