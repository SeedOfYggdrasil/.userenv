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
    if [ -n "$shell_loaded" ]; then
        exit 0 &>/dev/null
    fi
    export shell_loaded=1
}
chkshell

# Force reload shell
unload() {
    unset shell_loaded
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

    echo -e "${cyan}Loading shell${purplest}:${bold_purple}webnexus:${nc}"
	if [ -d "$dir" ]; then
		for file in "${files[@]}"; do
			[ -f "${dir}/$file" ] && source "${dir}/$file"
                echo -e "${bold_green}Loaded ${cyan}${file} ${bold_green} 
config!${nc}"
			sleep 0.3
		done
	setp 1
    fi
}

_env() {
    local file="$HOME/.env"
    if [ -e "$file" ] && [ -f "$file" ]; then
        source "$file"  
        vars=(
            PREFIX
            GH_TOKEN
        )
        for var in "${vars[@]}"; do
            if [ -n "$var" ]; then
                unset "$var"
            fi
        done
    fi
}

_nvm() {
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}


_load_shell() {
    _path
    _env
    _userenv
    _nvm
}

if [[ $- != *i* ]]; then
    exit 0
else
    clear
    _load_shell
    sleep 0.5
    clear
fi

# Other
if [ -f "$HOME/.userenv/prompt" ]; then
    alias prompt='$EDITOR ~/.userenv/prompt'
fi
