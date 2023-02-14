#!/bin/bash
# Copyright 2023 Adrian Robinson <adrian dot j dot robinson at gmail dot com>
# https://github.com/transilluminate/check-pia-vpn

PIA_LOCATION_INFO_URL="https://www.privateinternetaccess.com/site-api/get-location-info"
PIA_EXPOSED_CHECK_URL="https://www.privateinternetaccess.com/site-api/exposed-check"
DEBUG=true

# From https://github.com/pia-foss/manual-connections
check_tool() {
  command=$1
  if ! command -v "$command" >/dev/null; then
    echo "Error: command '$command' could not be found"
    exit 2
  fi
}
check_tool jq
check_tool curl

# Check if terminal allows output, if yes, define colors for output
if [[ -t 1 ]]; then
  ncolors=$(tput colors)
  if [[ -n $ncolors && $ncolors -ge 8 ]]; then
    red=$(tput setaf 1)		# ANSI red
    green=$(tput setaf 2)	# ANSI green
    nc=$(tput sgr0)		# (N)o (C)olor
  else
    red='';green='';nc=''
  fi
fi

locationInfoJSON=$(curl -s $PIA_LOCATION_INFO_URL)
if [[ $DEBUG == "true" ]]; then echo "External IP location information:" ; echo $locationInfoJSON | jq; fi

ipAddress=$(echo $locationInfoJSON | jq -r '.ip')
if [[ $DEBUG == "true" ]]; then echo -n "Checking external IP address ($ipAddress)... "; fi

isExposed=$(curl -s -X POST -H "Content-Type: application/json" -d '{"ipAddress": "'${ipAddress}'"}' $PIA_EXPOSED_CHECK_URL | jq -r '.status')
if [[ $isExposed == 'false' ]]; then
  echo "${green}true${nc}"; exit 0
else
  echo "${red}false${nc}"; exit 1
fi
