#!/bin/bash

# copy swarm configs to root
# this allows swarm configs to be modified
# also allows environment vars in any config file

CONFIG_DIR="${CONFIG_DIR:-/var/run/configs}"

mkdir -p ${CONFIG_DIR}
cd ${CONFIG_DIR}

for dir in $(ls); do
	for file in $(find $dir -type f); do
		mkdir -p /$(dirname ${file})
		if grep -q 'SUBOFF'  <<<"$(head -n1 ${file})"; then
			catt < "${CONFIG_DIR}/${file}" > "/${file}"
		else
			envsubst < "${CONFIG_DIR}/${file}" > "/${file}"
		fi
		chmod "$(stat -c '%a' ${CONFIG_DIR}/${file})" "/${file}"
	done
done
