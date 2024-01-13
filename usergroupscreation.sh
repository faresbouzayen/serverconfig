#!/bin/bash
if [[ $(id -u) -ne 0 ]]
then
    echo "You must login as root to create users and groups." >&2
    exit 1
fi