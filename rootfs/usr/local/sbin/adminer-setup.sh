#!/bin/bash

# Exit unless install requested
if [ -z ${ADMINER_INSTALL} ]; then
	exit 0
fi

# globals
export HTDOCS_DIR="${HTDOCS_DIR:-/var/www/html}"
export ADMINER_DIR="${ADMINER_DIR:-${HTDOCS_DIR}/adminer}"

# locals
ADMINER_URL="https://github.com/vrana/adminer/releases/download/v4.6.3/adminer-4.6.3.php"
ADMINER_CSS="https://raw.githubusercontent.com/vrana/adminer/master/designs/lucas-sandery/adminer.css"

# Install if needed
if [ ! -d "${ADMINER_DIR}" ]; then
    mkdir ${ADMINER_DIR}
    cd ${ADMINER_DIR}
    curl -sSL "${ADMINER_URL}" > index.php
    curl -sSL "${ADMINER_CSS}" > adminer.css
fi

# set/fix permissions for dbninja
chown -R ${APP_USER}:${APP_GROUP} ${HTDOCS_DIR}

