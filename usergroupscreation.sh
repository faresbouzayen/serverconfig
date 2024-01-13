#!/bin/bash
if [[ $(id -u) -ne 0 ]]
then
    echo "You must login as root to create users and groups." >&2
    exit 1
fi
separator=$'\n'
read -d '' -ra credentials < $1
separator='-'
for one in "${credentials[@]}"
Do
read usr grp <<< "$one"
useradd -m usr
getent group $grp || groupadd $grp
usermod -a -G $grp $usr
pass=$(cat /dev/urandom | tr -dc A-Za-z0-9 | head -c8)
