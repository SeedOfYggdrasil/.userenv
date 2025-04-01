#!/bin/bash

_rip_vars() {
	url=${1:-"https://www.risescience.com/category/blog"}
	dir=${2:-"."}
	domain=$(echo "$url" | awk -F[/:] '{print $4}')
	resume=""

	if [ ! -d "$dir" ]; then
		echo "Directory '${dir}' does not exist. Attempting to create it..."
		mkdir -p "$dir" && echo "Successfully created directory" || echo "Could not create directory" && return 1
	fi

	if [ -d "${dir}/${domain}" ]; then
		resume="-c"
		echo -e "${yellowest}Incomplete scrape detected. Resuming...${nc}"
	else
		echo -e "${purplest}Scraping files...${nc}"
	fi
	
}

_rip() {
	echo -e "(This may take awhile, please be patient...)"
	wget $resume \
	    --recursive \
	    --no-parent \
	    --convert-links \
	    --adjust-extension \
	    --page-requisites \
	    --no-clobber \
	    --span-hosts \
	    --domains="$domain" \
	    --reject-regex='.*logout.*' \
	    --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
	    --header="Accept-Language: en-US,en;q=0.9" \
	    --header="Referer: $url" \
	    --execute="robots=off" \
	    --limit-rate=5000k \
	    --wait=0.2 \
	    --random-wait \
	    --tries=20 \
	    --timeout=30 \
	    --output-file=wget.log \
	    -P "$dir" \
	     "$url" >&/dev/null && return 0 || return 1 

		if [ "$!" -eq 1 ]; then
	    	echo -e "${red}Failed${nc}: Could not scrape all files" && return 1
			return 1
		else
	    	echo -e "${greenest}Scraping Complete${nc}" && return 0
			return 0
		fi
}

rip() {
	_rip_vars
	_rip && return 0 || return 1
}
