#!/bin/bash

# copy swarm scripts to root
# this allows swarm scripts to be modified
# also allows environment vars in any config file

SCRIPT_DIR="${SCRIPT_DIR:-/var/run/scripts}"
TAG="$(basename $0 '.sh')"

mkdir -p ${SCRIPT_DIR}
cd ${SCRIPT_DIR}

for dir in $(ls); do
    for file in $(find $dir -type f); do
        echo "${TAG} Copying ${SCRIPT_DIR}/${file} to /${file}"
        dirname="/$(dirname ${file})"
        mode="$(stat -c '%a' ${SCRIPT_DIR}/${file})"
        if [ ! -d ${dirname} ]; then
            mkdir -m 755 -p ${dirname}
        fi
        cat < "${SCRIPT_DIR}/${file}" > "/${file}"
        #chmod $mode "/${file}"
        chmod 755 "/${file}"

	# run script if its target is this dir
        if [ "${dirname}" == "/etc/entrypoint.d/serial" ]; then
		"/$file"
	fi
    done
done
