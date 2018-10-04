#!/bin/bash

for file in /var/log/supervisor/*.log; do 
    tail -F -n +1 $file
done
