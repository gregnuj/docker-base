#!/bin/bash

scripts=/etc/entrypoint.d/*

for script in ${scripts}; do 
    $script
done

exec "$@"
