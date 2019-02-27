#!/bin/bash

TAG="$(basename $0 '.sh')"

echo "${TAG} generating ssh keys"
ssh-keygen -A

# fix permissions
if [ -f "/etc/ssh/ssh_config" ]; then
    chmod go+r /etc/ssh/ssh_config
fi

if [ -f "/etc/ssh/ssh_known_hosts" ]; then
chmod go+r /etc/ssh/ssh_known_hosts
fi

if [ -f "/etc/ssh/sshd_config" ]; then
    chmod go+r /etc/ssh/sshd_config
fi

