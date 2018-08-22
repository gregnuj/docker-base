#!/bin/bash

# copy swarm configs to root
# this allows swarm configs to be modified
# also allows environment vars in any config file

CONFIG_DIR="${CONFIG_DIR:-/var/run/configs}"
TAG="$(basename $0 '.sh')"

mkdir -p ${CONFIG_DIR}
cd ${CONFIG_DIR}

for dir in $(ls); do
	for file in $(find $dir -type f); do
		echo "${TAG} Copying ${CONFIG_DIR}/${file} to /${file}"
		dirname="$(dirname ${file})"
		mode="$(stat -c '%a' ${CONFIG_DIR}/${file})"
		if [ ! -d ${dirname} ]; then
			mkdir -m ${mode} -p ${dirname}
		fi
		if grep -q 'SUBOFF'  <<<"$(head -n1 ${file})"; then
			cat < "${CONFIG_DIR}/${file}" > "/${file}"
		else
			envsubst < "${CONFIG_DIR}/${file}" > "/${file}"
		fi
		chmod $mode "/${file}"
	done
done
