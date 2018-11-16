#!/bin/bash

# copy swarm scripts to root
# this allows swarm scripts to be modified
# also allows environment vars in any config file

CONFIG_DIR="${CONFIG_DIR:-/var/run/scripts}"
TAG="$(basename $0 '.sh')"

mkdir -p ${CONFIG_DIR}
cd ${CONFIG_DIR}

for dir in $(ls); do
    for file in $(find $dir -type f); do
        echo "${TAG} Copying ${CONFIG_DIR}/${file} to /${file}"
        dirname="/$(dirname ${file})"
        mode="$(stat -c '%a' ${CONFIG_DIR}/${file})"
        if [ ! -d ${dirname} ]; then
            mkdir -m 755 -p ${dirname}
        fi
        cat < "${CONFIG_DIR}/${file}" > "/${file}"
        chmod $mode "/${file}"
    done
done
