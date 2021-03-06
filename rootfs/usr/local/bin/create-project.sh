#!/bin/bash

# similar to composer --create-project
# but does not require git vcs config in advance

export APP_USER="${APP_USER:-cyclops}"
export APP_GROUP="${APP_GROUP:-${APP_USER}}"
export APP_EMAIL="${APP_EMAIL:-${APP_USER}@localhost}"
export HTDOCS_DIR="${HTDOCS_DIR:-/var/www/html}"
export PROJECT_DIR="${PROJECT_DIR:-${HTDOCS_DIR}/${APP_NAME}}"
export PROJECT_GIT_URL="${PROJECT_GIT_URL}"
export PROJECT_GIT_BRANCH="${PROJECT_GIT_BRANCH:-master}"
export NPM_CONFIG_PREFIX="${PROJECT_DIR}/.npm-global"

git config --global user.name "${APP_USER}"
git config --global user.email "${APP_EMAIL}"
git config --global credential.helper store

if [ -n "$PROJECT_GIT_URL" ]; then
    # sleep random amount to avoid collision
    sleep $(( $RANDOM % 3 +  $RANDOM % 5 ))
    if [ ! "$(ls -A ${PROJECT_DIR})" ]; then
        git clone -b "$PROJECT_GIT_BRANCH" "$PROJECT_GIT_URL" "$PROJECT_DIR"
    fi
    cd $PROJECT_DIR
    if [ -f "./composer.json" ]; then
        composer update -n
    fi
fi

if [ -n "$PROJECT_ENV" ]; then
    if [ ! -e "${HTDOCS_DIR}/${PROJECT_ENV}" ]; then
         ln -s "${HTDOCS_DIR}" "${HTDOCS_DIR}/${PROJECT_ENV}"
    fi 
fi

# set/fix permissions for project
if [ -d "${PROJECT_DIR}" ]; then
    chown -R ${APP_USER}:${APP_GROUP} ${PROJECT_DIR}
fi

