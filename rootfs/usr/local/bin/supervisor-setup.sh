#!/bin/bash

# globals
export APP_USER="${APP_USER:-cyclops}"
export SUPERVISOR_INI=${SUPERVISOR_INI:-/etc/supervisor.d/default.ini}
export SUPERVISOR_SECRET="${SUPERVISOR_SECRET:-/var/run/secrets/app_password}"

# links supervisord files to debian location
if [ -d "/etc/supervisor/conf.d" ]; then
	for file in $(ls /etc/supervisor.d/*.ini); do
		ln -s $file /etc/supervisor/conf.d/$(basename $file '.ini').conf
	done
fi

# Get supervisor password
if [ -z "${APP_PASSWD}" ]; then
	# Create webconsole secret if it does not exist
	if [ ! -f "${SUPERVISOR_SECRET}" ]; then
		openssl rand -base64 10 > ${SUPERVISOR_SECRET}
	fi
	APP_PASSWD="$(echo -n $(sudo cat ${SUPERVISOR_SECRET}))"
fi


# Set supervisor user/password 
sed -i \
	-e "s/^username = .*$/username = ${APP_USER}/" \
	-e "s/^password = .*$/password = ${APP_PASSWD}/" \
	${SUPERVISOR_INI}

