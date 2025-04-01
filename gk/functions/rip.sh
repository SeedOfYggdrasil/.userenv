#!/bin/bash

_rip_list() {
	local domain=$1 
	local cmd1="curl http://${domain}/sitemap.txt | grep -E '\.(zip|tar\.gz|txt)$' > ${dir}/${domain}_files.txt"	
	local cmd2="wget -r -np -nd -A '*' http://${domain}/files"	
	local file_list="${dir}/${domain}_files.txt"

	eval "$cmd1" && filelist="-i $file_list" || eval "$cmd2" || return
}

_rip_vars() {
	url=${1:-"https://colorlib.com/wp/template/videograph"}
	dir=${2:-"$HOME/rips"}
	domain=$(echo "$url" | awk -F[/:] '{print $4}')
	resume=""
	filelist=""

	if [ ! -d "$dir" ]; then
		echo "Directory '${dir}' does not exist. Attempting to create it..."
		mkdir -p "$dir" || echo "Failed" && return 1
	fi

	if [ -d "${dir}/${domain}" ]; then
		resume="-c"
	fi

	_rip_list $domain
	filelist=$filelist
}

_rip() {		
	wget $resume $filelist \
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
	    --limit-rate=1000k \
	    --wait=1 \
	    --random-wait \
	    --tries=20 \
	    --timeout=30 \
	    --output-file=wget.log \
	    -P "$dir" "$url"

    log_file="${dir}/${domain}_progress.log"
    tail -f "$log_file" | awk '
        /Saving to:/ { 
            file=$3; 
        } 
        /\.\.\./ { 
            gsub("\\.+", "=", $0); 
            progress="[" substr($0, 1, length($0)-4) "]";
            percent=gensub(".* ([0-9]+)%.*", "\\1", 1);
            printf "\r%s %s %s%%", file, progress, percent;
            fflush();
        }
    END { print ""; }'
}

rip() {
	_rip_vars  
	_rip
	echo "Done"
}


rip
