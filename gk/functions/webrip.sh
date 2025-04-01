#!/bin/bash

# webrip.sh | v.1.0 | 12.25.24
# Developed by Alex Pariah

# Usage:
#   `webrip [URL_1] [URL_2] [...]`
# Description:
#   Downloads ALL files of one or more websites to a local 
#   directory, without compromising existing architecture.

_webrip_prompt() {
    read -r -p "Set Download Directory: " dl_dir

    if [ ! -d "$dl_dir" ]; then
        local script="$HOME/.gk/functions/userprompt.sh"

        if [ -f "$script" ]; then
            source "$script"
            userprompt "Directory does not exist. Create it?"

            if [ "$choice_1" == "YES" ]; then
                mkdir -p "$dl_dir"
                echo "Directory created: $dl_dir"
            else
                echo "Exiting..."
                return 1
            fi
        else
            echo "Error: User prompt script not found."
            return 1
        fi
    fi

    echo "export DOWNLOAD_DIR=${dl_dir}" >> "$config"
    source "$config"
    echo "Download directory set to '${DOWNLOAD_DIR}'"
}

_webrip() {
	local domains=$1
	local dir=$2
	local url=$3
	local counter=$4
	
	wget \
	    --recursive \                
	    --no-parent \                
	    --convert-links \            
	    --adjust-extension \         
	    --page-requisites \          
	    --no-clobber \               
	    --span-hosts \               
	    --domains="$domains" \       
	    --reject-regex='.*logout.*' \
	    --user-agent="Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)" \ # Bypass user-agent blockers
	    --header="Accept-Language: en-US,en;q=0.9" \
	    --warc-file=site_mirror \    
	    --execute="robots=off" \     
	   #--limit-rate=100k \          
	   #--wait=2 \                   
	   #--random-wait \              
	    --tries=20 \                 
	    --timeout=30 \               
	    --output-file=wget.log \     

	    -P "$dir" \
	                      
	    "$url" || echo "Site ${counter}: Download Failed" && return 1

		echo "Site ${counter}: Download Complete" && return 0
}

webrip() {
    local urls=("$@")
    local domains=()
    local config="$HOME/.webrip/webrip.conf"

    if [ -z "$DOWNLOAD_DIR" ]; then
        if [ -f "$config" ]; then
            source "$config"
        else
            _webrip_prompt || return 1
        fi
    fi

    for url in "${urls[@]}"; do
        domain=$(echo "$url" | awk -F[/:] '{print $4}')
        domains+=("$domain")
    done

    local domains_list=$(IFS=,; echo "${domains[*]}")
    local counter=1

    for url in "${urls[@]}"; do
        echo "Site ${counter}: Download Start"
        _webrip "$domains_list" "$DOWNLOAD_DIR" "$url" "$counter" || return 1
        echo "Site ${counter}: Download Complete"
        ((counter++))
    done
}
