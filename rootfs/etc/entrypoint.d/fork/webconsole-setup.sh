#!/bin/bash

# Exit unles intall requested
if [ -z ${WEBCONSOLE_INSTALL} ]; then
	exit 0
fi

# globals
export APP_USER="${APP_USER:-root}"
export APP_GROUP="${APP_GROUP:-${APP_USER}}"
export APP_HOME="${APP_HOME:-/home/${APP_USER}}"
export HTDOCS_DIR="${HTDOCS_DIR:-/var/www/html/}"
export WEBCONSOLE_DIR="${WEBCONSOLE_DIR:-${HTDOCS_DIR}/webconsole}"
export WEBCONSOLE_PHP="${WEBCONSOLE_PHP:-${WEBCONSOLE_DIR}/webconsole.php}"
export http_proxy="${http_proxy:-${HTTP_PROXY}}"
export https_proxy="${https_proxy:-${HTTPS_PROXY}}"

# locals
WEBCONSOLE_ZIP="webconsole-0.9.7.zip"
WEBCONSOLE_URL="https://github.com/nickola/web-console/releases/download/v0.9.7/${WEBCONSOLE_ZIP}"
WEBCONSOLE_SECRET="${WEBCONSOLE_SECRET:-/var/run/secrets/app_password}"
TAG="$(basename $0 '.sh')"

# Install if needed
if [ ! -e "${WEBCONSOLE_DIR}" ]; then
    echo "${TAG} Cloning webconsole to ${WEBCONSOLE_DIR}"
    wget ${WEBCONSOLE_URL}
    unzip ${WEBCONSOLE_ZIP} -d ${HTDOCS_DIR}
    mv ${HTDOCS_DIR}/webconsole ${WEBCONSOLE_DIR}
    rm ${WEBCONSOLE_ZIP}
fi

# Get weconsole password 
if [ -z "${APP_PASSWD}" ]; then
	# Create webconsole secret if it does not exist
	if [ ! -f "${WEBCONSOLE_SECRET}" ]; then
		openssl rand -base64 10 > ${WEBCONSOLE_SECRET}
	fi
	APP_PASSWD="$(echo -n $(cat ${WEBCONSOLE_SECRET}) | sha256sum | awk '{print $1}')"
fi

# Set weconsole user/password 
echo "${TAG} Setting user/pwd for webconsole"
sed -i \
	-e "s/^\$USER = .*\$/\$USER = \"${APP_USER}\";/" \
	-e "s/^\$PASSWORD = .*\$/\$PASSWORD = \"${APP_PASSWD}\";/" \
	-e "s/^\$PASSWORD_HASH_ALGORITHM = .*\$/\$PASSWORD_HASH_ALGORITHM = \"sha256\";/" \
	-e "s/^\$HOME_DIRECTORY = .*\$/\HOME_DIRECTORY = \"${APP_HOME}\";/" \
	${WEBCONSOLE_PHP}

if [ ! -e "${WEBCONSOLE_DIR}/index.php" ]; then
    ln -s ${WEBCONSOLE_PHP} ${WEBCONSOLE_DIR}/index.php
fi 

# set/fix permissions for webconsole
echo "${TAG} Setting owner of ${WEBCONSOLE_DIR} to ${APP_USER}"
chown -R ${APP_USER}:${APP_GROUP} ${WEBCONSOLE_DIR}

