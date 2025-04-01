#!/bin/bash

rip_ping() {
  local domain=$1

  echo
  echo -e "${yellow}Target Domain: ${bold_blue}$domain${nc}"
  echo -e "${yellow}Local Directory: ${bold_blue}$dir${nc}"
  echo
  echo -e "${bold_purple}Attempting to connect to ${bold_blue}$domain${nc}"



  if ! command ping -c 1 $domain &>/dev/null; then
    echo
    echo -e "${bold_red}Error${nc}: Connection refused."
    return 1
  else
    echo -e "${green}Connected!${nc}"
  fi

}

rip_own() {
  local domain=$1
  local dir=$2
  local webroot=$dir/$domain

  chown -R $USER:$USER $webroot || sudo chown -R $USER:$USER $webroot || return 0
  chmod -R 755 $webroot || sudo chmod -R 755 $webroot || return 0

  }

rip_cmd() {
  local domain=$1
  local dir=$2

  echo
  echo -e "${bold_purple}Scraping webfiles...${nc}"
  echo

  wget -r -np -k -E -p -nc --span-hosts --domains=$domain -P $dir $url &>/dev/null

  if [ $? -eq 0 ]; then
    echo -e "${green}Successfully scraped webfiles!${nc}"
  else
    echo -e "${bold_red}Error${nc}: Could not scrape webfiles."
    return 3
  fi

}

rip_wrapper() {
  local domain=$1
  local dir=${2:-"$(pwd)"}
  local url="https://${domain}"

  if [ ! -d $dir ]; then
    echo -e "${bold_red}Error${nc}: Invalid download directory."
    return 2
  fi

  if [ -z $domain ]; then
    read -p "Target Domain:${bold_blue} ${nc}" domain
  fi

  rip_ping "$domain"
  rip_cmd "$domain" "$dir"

}

rip() {
  local domain=$1
  local dir=$2
  rip_wrapper "$domain" "$dir"
}
