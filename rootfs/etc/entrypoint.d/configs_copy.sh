#!/bin/bash

CONFIG_DIR="${CONFIG_DIR:-/var/run/configs}"

mkdir -p ${CONFIG_DIR}
cd ${CONFIG_DIR}

for dir in $(ls); do
	for file in $(find $dir -type f); do
		mkdir -p /$(dirname ${file})
		cp ${CONFIG_DIR}/${file} /$file
	done
done
