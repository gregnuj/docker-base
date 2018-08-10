#!/bin/bash

# Exit unless install requested
if [ -z ${ADMINER_INSTALL} ]; then
	exit 0
fi

# locals
ADMINER_BASE="${ADMINER_BASE:-/var/www/html/}"
ADMINER_DIR="${ADMINER_DIR:-${ADMINER_BASE}/adminer}"
ADMINER_URL="https://github.com/vrana/adminer/releases/download/v4.6.3/adminer-4.6.3.php"


# Install if needed
if [ ! -d "${ADMINER_DIR}" ]; then
    mkdir ${ADMINER_DIR}
    cd ${ADMINER_DIR}
    curl -sS "${ADMINER_URL}" > index.php
fi

# set/fix permissions for dbninja
chown -R ${APP_USER}:${APP_GROUP} ${ADMINER_BASE}

