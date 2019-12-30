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

# Original command:
# openssl pkcs12 -export -out certificate.p12 -inkey privateKey.key -in certificate.crt -certfile CACert.crt

# Emojis because this was written by a millenial, ok boomer?
SUCCESS=$(printf "✅")
FAILURE=$(printf "❌")
MISSING=$(printf "🤔")
DONE=$(printf "🚀")
WARNING=$(printf "⚠️")

# CLI help
HELPTEXT="
Convert PEM bundle to PFX/PCKS12
    
    -h      Show this help menu.
    -c      Cert file name.
    -k      Key file name.
    -a      CA bundle file name.
    -o      Destination PFX file name.
    -p      Import/Export password.
    -f      Import/Export password file name. [OPTIONAL - default is current working directory]
    -d      Show debug output $WARNING  THIS WILL SHOW PASSWORDS $WARNING
"

# Variable defaults
CERT_FILE="EMPTY"
KEY_FILE="EMPTY"
CA_FILE="EMPTY"
PFX_FILE="EMPTY"
PASSWORD="EMPTY"
PW_FILE="export_password.txt"

# Print help message when required arguments are missing
function missing_args() {
    echo -e "\n$MISSING Usage: $0 [ -c CERT FILE ] [ -k KEY FILE ] [ -a CA FILE ] [ -p EXPORT PASSWORD ] [ -o PFX FILE ]\n" 1>&2
    exit 1
}

# Print help message when no arguments are provided
if (($# == 0)); then
  missing_args
fi

# Reassign variables with provided arguments
while getopts "hdc:k:a:o:p:" options; do
  case "${options}" in
    h)
      echo -e "$HELPTEXT"
      exit 0
      ;;
    d)
      DEBUG=1
      ;;
    c)
      CERT_FILE=${OPTARG}
      ;;
    k)
      KEY_FILE=${OPTARG}
      ;;
    a)
      CA_FILE=${OPTARG}
      ;;
    o)
      PFX_FILE=${OPTARG}
      ;;
    p)
      PASSWORD=${OPTARG}
      ;;
    f)
      PW_FILE=${OPTARG}
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

# If debugging is enabled, print the provided arguments to ensure they were properly interpreted
if [ "$DEBUG" == 1 ]; then
    echo -e "\nDebug Mode On. Arguments:\n
    -c:     $CERT_FILE
    -k:     $KEY_FILE
    -a:     $CA_FILE
    -o:     $PFX_FILE
    -p:     $PASSWORD
    -f:     $PW_FILE
    "
fi

# Array of file path variables to check
CHECK_BEFORE=($CERT_FILE $KEY_FILE $CA_FILE)

# Verify files exist before proceeding
for file in "${CHECK_BEFORE[@]}";
    do
        test -f $file;
        if [ $? -eq 0 ]; then
            if [ "$DEBUG" == 1 ]; then
                echo "$SUCCESS $file"
            else
                :
            fi
        else
            echo -e "\n$FAILURE $file [NOT FOUND]\n"
            exit 1
        fi
    done

# Write the password in plain text to file
if [ ! "$PASSWORD" == "EMPTY" ]; then
    echo "$PASSWORD" > $PW_FILE
else
    missing_args
fi

# Execute the actual openssl command with validated variables
if [ ! "$PFX_FILE" == "EMPTY" ] && [ ! "$KEY_FILE" == "EMPTY" ] && [ ! "$CA_FILE" == "EMPTY" ] && [ ! "$CERT_FILE" == "EMPTY" ] && [ ! "$PASSWORD" == "EMPTY" ]; then
    openssl pkcs12 -export -in "$CERT_FILE" -inkey "$KEY_FILE" -certfile "$CA_FILE" -passout pass:"$PASSWORD" -out "$PFX_FILE"
else
    missing_args
fi

# Array of file paths to check
CHECK_AFTER=($PFX_FILE $PW_FILE)

# Verify written files were actually written
if [ $? -eq 0 ]; then
    echo ""
    for file in "${CHECK_AFTER[@]}";
        do
            test -f $file;
            if [ $? -eq 0 ]; then
                echo -e "$SUCCESS wrote $file"
            else
                echo -e "$FAILURE unable to write $file"
                exit 1
            fi
        done
    echo -e "\n      $DONE\n   $DONE\n$DONE"
fi
exit 0
