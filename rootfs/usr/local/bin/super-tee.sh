#!/bin/bash

declare -a PIDS

for file in /var/log/supervisord/*.log; do 
    tail -F -n +1 $file &
    PIDS="$PIDS $!"
done

for pid in $PIDS; do 
	wait $pid
done

