# ~/.bashrc

case $- in
    *i*) ;;
      *) return;;
esac

prep_gui() {
    local f=$HOME/.loud_gui.sh

    if [ -e "$f" ] && [ -f "$f" ]; then
        source "$f" || return 1
    fi
}
prep_gui

chkshell() {
    if [ "$shell_loaded" -ne 1 ]; then
        exit 0 &>/dev/null
    fi
 
    export shell_loaded=1
}
chkshell

# Force reload shell
unload() {
    unset loaded
    source ~/.bashrc
}

# Add default user-scripts to PATH
_path() {
    export PATH=$PATH:/home/vps/.local/bin 
}

# Load custom environment
_userenv() {
	files=(
		color	# human-readable color-code variables
        prompt	# command prompt configuration
		server  # web-server configurations
        user	# user-specific configurations
    )
	local dir=$HOME/.userenv 

    echo -e "${cyan}Loading shell${purplest}:${yellow}#!/bin/bash${purplest}:${nc}"
	if [ -d "$dir" ]; then
		for file in "${files[@]}"; do
			[ -f "${dir}/$file" ] && source "${dir}/$file"
			echo -e "${green}	successfully loaded ${bold_purple}${file}${green} configuration${nc}"
			sleep 0.3
		done
	fi
}

_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

_env() {
    local file="$HOME/.env"
    if [ -e "$file" ] && [ -f "$file" ]; then
        source "$file"  
    fi

    vars=(
        PREFIX
        GH_TOKEN
    )
    for var in "${vars[@]}"; do
        if [ -n "$var" ]; then
            unset "$var"
        fi
    done
}

_load_shell() {
    clear
    _path
    _env
    _userenv
    _nvm
    sleep 0.5
    clear
}

if [[ $- != *i* ]]; then
    exit 0
else
    _load_shell && export shell_loaded=1
fi
