#!/bin/bash

# skip install unless requested
if [ -z "$CODIAD_INSTALL" ]; then
	exit 0
fi

# may need to set these
export APP_USER="${APP_USER:-cyclops}"
export APP_GROUP="${APP_GROUP:-${APP_USER}}"
export PROJECT_DIR="${PROJECT_DIR:-$(pwd)/${APP_NAME}}"
export CODIAD_BASE="${CODIAD_BASE:-/var/www/html/${APP_NAME}-codiad}"
export CODIAD_DATA="${CODIAD_DATA:-${CODIAD_BASE}/data}"

# settings files
CODIAD_SECRET="${CODIAD_SECRET:-/var/run/secrets/app_password}"
CODIAD_PROJECTS="${CODIAD_PROJECTS:-${CODIAD_DATA}/projects.php}"
CODIAD_SETTINGS="${CODIAD_SETTINGS:-${CODIAD_DATA}/settings.php}"
CODIAD_USERS="${CODIAD_USERS:-${CODIAD_DATA}/users.php}"
CODIAD_TZ="${CODIAD_TZ:-America/Chicago}"

# Download and install
if [ ! -e "${CODIAD_BASE}" ]; then
	git clone https://github.com/Codiad/Codiad ${CODIAD_BASE}
	sed -i -e 's/mb_ord/xmb_ord/g' -e 's/mb_chr/xmb_chr/g' ${CODIAD_BASE}/lib/diff_match_patch.php
fi

# set/fix permissions for codiad
chown -R ${APP_USER}:${APP_GROUP} ${CODIAD_BASE}

# populate users
if [[ ! -f "${CODIAD_USERS}" || ! -f "${CODIAD_PROJECTS}" || ! -f "${CODIAD_PROJECTS}" ]]; then
	# set variable for use in CODIAD_USERS
	if [ -z "${APP_PASSWD}" ]; then
		# Create codiad secret if it does not exist
		if [ ! -f "${CODIAD_SECRET}" ]; then
			openssl rand -base64 10 > ${CODIAD_SECRET}
		fi
		APP_PASSWD="$(cat ${CODIAD_SECRET})"
	fi
	DATA="path=${CODIAD_BASE}"
	DATA+="&username=${APP_USER}"
	DATA+="&password=${APP_PASSWD}"
	DATA+="&password_confirm=${APP_PASSWD}"
	DATA+="&project_name=${APP_NAME}"
	DATA+="&project_path=${PROJECT_DIR}"
	DATA+="&timezone=${CODIAD_TZ}"

	# remove existing and create new
	for file in ${CODIAD_DATA}/*.php; do
		rm $file
	done
	curl -sS http://127.0.0.1/codiad/components/install/process.php --data "${DATA}"
fi


