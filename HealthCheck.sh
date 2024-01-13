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

# Processing for path un-accepted characters using Sed utility
1ABSOLUTEPATHDIRECTORY=$(echo $ABSOLUTEPATHDIRECTORY | sed -n '/^[a-zA-Z0-9\/_-]*$/p' )
1HTTPDIRECTORY=$(echo $HTTPDIRECTORY | sed -n '/^[a-zA-Z0-9\/_-]*$/p' )

# Config backup
cp /etc/apache2/sites-available/000-default.conf /etc/apache2/l/sites-available/000-default.conf.backup
sed -i "s/$1HTTPDIRECTORY/$1ABSOLUTEPATHDIRECTORY/g" /etc/apache2/sites-available/000-default.conf

# Restart to use the new configuration
systemctl reload apache2

if [[ $? -ne 0 ]]
then
    cp /etc/apache2/sites-available/000-default.conf.backup /etc/apache2/sites-available/000-default.conf
    echo "Syntax error might be your cause of issue . . . "
    systemctl stop apache2
    systemctl start apache2
    return 1
fi
# Do not allow other channels than these
ufw allow http
ufw allow https
