#!/bin/bash

# links supervisord files to debian location

if [ -d "/etc/supervisor/conf.d" ]; then
    for file in $(ls /etc/supervisor.d/*.ini); do
        ln -s $file /etc/supervisor/conf.d/$(basename $file '.ini').conf
    done
fi
