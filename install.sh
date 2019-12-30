#!/usr/bin/env bash
#
# https://github.com/checktheroads/pem-to-pfx
#
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
# Version 2, December 2004 
# 
# Copyright (C) 2019 Matthew Love <matt@allroads.io> 
# 
# Everyone is permitted to copy and distribute verbatim or modified 
# copies of this license document, and changing it is allowed as long 
# as the name is changed. 
# 
# DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE 
# TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION 
# 
# 0. You just DO WHAT THE FUCK YOU WANT TO.
#

# Variable defaults
PEM_TO_PFX="https://raw.githubusercontent.com/checktheroads/pem-to-pfx/master/pem-to-pfx.sh"
COMMAND_NAME="pem-to-pfx"
DEST_PATH="/usr/local/bin/"
COMMAND_PATH="$DEST_PATH$COMMAND_NAME"

# Emojis because this was written by a millenial, ok boomer?
SUCCESS=$(printf "✅")
FAILURE=$(printf "❌")

# CLI help
HELPTEXT="
Convert PEM bundle to PFX/PCKS12
    
    -h      Show this help menu.
    -n      Name of command. [Default: pem-to-pfx]
    -p      Path to command. [Default: $DEST_PATH]
"

# Verify the file exists
function check_url () {
    # Get headers for URL, if status code is not 200, raise error
    STATUS=$(curl -L -s -I $PEM_TO_PFX 2>/dev/null | head -n 1 | cut -d$' ' -f2)
    if [[ $STATUS != "200" ]]; then
        echo -e "$FAILURE File does not exist"
        exit 1
    else
        :
    fi
}

# Error message for download failure
function dl_error () {
    echo -e "$FAILURE Download Failed"
    exit 1
}

# Message for download success
function dl_success () {
    echo -e "$SUCCESS Installation Succeeded"
    exit 0
}

# Download script to path
function download () {
    check_url
    curl -L -s -o $COMMAND_PATH $PEM_TO_PFX
    if [ $? -eq 1 ]; then
        dl_error
    else
        chmod +x $COMMAND_PATH
        dl_success
    fi
}

# Print help message when no arguments are provided
if (($# == 0)); then
  download
fi

# Reassign variables with provided arguments
while getopts "hn:p:" options; do
  case "${options}" in
    h)
      echo -e "$HELPTEXT"
      exit 0
      ;;
    n)
      COMMAND_NAME=${OPTARG}
      ;;
    p)
      DEST_PATH=${OPTARG}
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))

download
