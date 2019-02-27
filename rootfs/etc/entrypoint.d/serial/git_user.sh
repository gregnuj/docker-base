#!/bin/bash

# GIT may needs diff user settings
export GIT_USER="${GIT_USER:-${APP_USER}}"
export GIT_EMAIL="${GIT_EMAIL:-${APP_EMAIL}}"

# script name for logging
TAG="$(basename $0 '.sh')"

# git settings
echo "${TAG}: Setting GIT user as ${GIT_USER} <${GIT_EMAIL}>"
git config --global user.name "${GIT_USER}"
git config --global user.email "${GIT_EMAIL}"
git config --global credential.helper store
