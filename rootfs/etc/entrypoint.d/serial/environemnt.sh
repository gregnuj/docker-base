#!/bin/bash

# script name for logging
TAG="$(basename $0 '.sh')"
# store env in /etc/environment
echo "${TAG}: Storing ENV variables in /etc/environment"
printenv | egrep -v '^(_|PWD|PHP|HOME)' | awk -F '=' '{print $1"=\""$2"\""}' >> /etc/environment


