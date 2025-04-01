# ~/.bashrc

case $- in
    *i*) ;;
      *) return;;
esac

prep_gui() {
    local f=$HOME/.load_gui.sh

    if [ -e "$f" ] && [ -f "$f" ]; then
        source "$f" || return 1
    fi
}
# prep_gui

chkshell() {
    if [ "$shell_loaded" -ne 1 ]; then
        exit 0 &>/dev/null
    fi
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
		server  # web-server configurations
        user	# user-specific configurations
        prompt  # customize prompt
    )
	local dir=$HOME/.userenv 

    echo -e "${cyan}Loading shell${purplest}:${yellow}$HOSTNAME${purplest}:${nc}"
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
    _path
    _env
    _userenv
    _nvm
}

if [[ $- != *i* ]]; then
    exit 0 &>/dev/null
else
    clear
    _load_shell 
    export shell_loaded=1
    sleep 0.5
    clear
    setp 1
fi
