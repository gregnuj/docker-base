#!/bin/bash

# globals
export APP_USER="${APP_USER:-cyclops}"
export APP_GROUP="${APP_GROUP:-${APP_USER}}"
export HTDOCS_DIR="${HTDOCS_DIR:-/var/www/html}"

# locals
TAG="$(basename $0 '.sh')"

# set/fix permissions for htdocs
echo "${TAG} Setting owner of ${HTDOCS_DIR} to ${APP_USER}"
chown -R ${APP_USER}:${APP_GROUP} ${HTDOCS_DIR}

