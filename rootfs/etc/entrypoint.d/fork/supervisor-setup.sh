#!/bin/bash

# globals
export APP_USER="${APP_USER:-cyclops}"
export SUPERVISOR_INI=${SUPERVISOR_INI:-/etc/supervisor.d/default.ini}
export SUPERVISOR_SECRET="${SUPERVISOR_SECRET:-/var/run/secrets/app_password}"
TAG="$(basename $0 '.sh')"

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
	APP_PASSWD="$(echo -n $(cat ${SUPERVISOR_SECRET}) | sha1sum | awk '{print $1}')"
fi


# Set supervisor user/password 
echo "${TAG} Setting user/pwd for webconsole"
sed -i \
	-e "s/^username = .*$/username = ${APP_USER}/" \
	-e "s/^password = .*$/password = {SHA}${APP_PASSWD}/" \
	${SUPERVISOR_INI}

# chmod conf file 
chmod -R go+rX /etc/supervisor*

# chmod log file
chmod -R go+rX /var/log/supervisor*
