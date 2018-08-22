#!/bin/bash

scripts=/etc/entrypoint.d/*

for script in ${scripts}; do 
    echo "$0: running $script"
    $script
done

exec $@
