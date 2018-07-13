#!/bin/bash

APP_UID="${APP_UID:-10000}"
APP_USER="${APP_USER:-cyclops}"
APP_HOME="${APP_HOME:-/home/${APP_USER}}"
APP_SSH="${APP_SSH:-${APP_HOME}/.ssh}"
APP_KEY="${APP_KEY:-${APP_SSH}/id_rsa}"
APP_AUTH="${APP_AUTH:-${APP_SSH}/authorized_keys}"

addgroup --gid ${APP_UID} ${APP_USER}
adduser --disabled-login --uid ${APP_UID} --group ${APP_USER} ${APP_USER}

if [ -n "${APP_SUDO}" ]; then
    echo "${APP_SUDO} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

mkdir -p ${APP_SSH}
if [ -f "${APP_KEY}" ]; then
    cp ${APP_KEY} ${APP_KEY}
    ssh-keygen -y -f ${APP_KEY} > ${APP_AUTH}
fi

chown -R ${APP_USER}:${APP_USER} ${APP_HOME}

