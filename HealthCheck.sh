#!/bin/bash

# Check if user is root
if [ "$(id -u)" -ne 0 ]; then
    echo "Failed! Run the script as root!" >&2
    exit 1
fi

# Check the number of enabled sites
if [ "$(find /etc/apache2/sites-enabled -maxdepth 1 -type l | wc -l)" -ne 1 ]; then
    echo "You must have only one website configured" >&2
    exit 1
fi

# Get configured HTTP DIRECTORY
HTTPDIRECTORY=$(awk '/DocumentRoot/ {print $2}' /etc/apache2/sites-available/000-default.conf | cut -d '/' -f 2-)
echo "Configured HTTP DIRECTORY is /$HTTPDIRECTORY"

# Prompt user for new absolute path for DocumentRoot
read -p "Press Enter to accept the given value or enter the new absolute path for the new DocumentRoot: " ABSOLUTEPATHDIRECTORY
ABSOLUTEPATHDIRECTORY=${ABSOLUTEPATHDIRECTORY:-$HTTPDIRECTORY}
