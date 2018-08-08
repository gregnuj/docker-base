#!/bin/bash

# similar to composer --create-project
# but does not require git vcs config in advance

export APP_USER="${APP_USER:-cyclops}"
export APP_GROUP="${APP_GROUP:-${APP_USER}}"
export APP_EMAIL="${APP_EMAIL:-${APP_USER}@localhost}"
export PROJECT_DIR="${PROJECT_DIR:-$(pwd)/${APP_NAME}}"
export PROJECT_GIT_URL="${PROJECT_GIT_URL}"
export PROJECT_GIT_BRANCH="${PROJECT_GIT_BRANCH:-master}"

git config --global user.name "${APP_USER}"
git config --global user.email "${APP_EMAIL}"

if [ -n "$PROJECT_GIT_URL" ]; then
	# sleep random amount to avoid collision
	sleep $(( $RANDOM % 3 +  $RANDOM % 5 ))
	if [ ! "$(ls -A ${PROJECT_DIR})" ]; then
		git clone -b "$PROJECT_GIT_BRANCH" "$PROJECT_GIT_URL" "$PROJECT_DIR"
	fi
	if [ -f "./composer.json" ]; then
		composer update
	fi
fi

# set/fix permissions for project
if [ -d "${PROJECT_DIR}" ]; then
    chown -R ${APP_USER}:${APP_GROUP} ${PROJECT_DIR}
fi

