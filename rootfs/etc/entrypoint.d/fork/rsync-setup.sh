#!/bin/bash

# globals
export APP_USER="${APP_USER:-root}"
export RSYNC_SECRET="${RSYNC_SECRET:-/var/run/secrets/app_password}"
export RSYNC_SECRET_FILE="${RSYNC_SECRET_FILE:-/etc/rsync.secreta}"

TAG="$(basename $0 '.sh')"

# Get weconsole password 
echo "${TAG} Setting user/pwd for rsync"
if [ -z "${APP_PASSWD}" ]; then
	# Create webconsole secret if it does not exist
	if [ ! -f "${RSYNC_SECRET}" ]; then
		openssl rand -base64 10 > ${RSYNC_SECRET}
	fi
	APP_PASSWD="$(echo -n $(cat ${RSYNC_SECRET}))"
fi

# Set rsync user/password 
echo "${APP_USER}:${APP_PASSWD}" >> ${RSYNC_SECRET_FILE}
