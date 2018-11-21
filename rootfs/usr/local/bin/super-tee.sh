#!/bin/bash

for file in /var/log/supervisord/*.log; do 
    tail -F -n +1 $file &
done
