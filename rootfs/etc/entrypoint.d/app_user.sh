#!/bin/bash

APP_UID="${APP_UID:-10000}"
APP_GID="${APP_GID:-${APP_UID}}"
APP_USER="${APP_USER:-cyclops}"
APP_HOME="${APP_HOME:-/home/${APP_USER}}"
APP_SSH="${APP_SSH:-${APP_HOME}/.ssh}"
APP_KEY="${APP_KEY:-${APP_SSH}/id_rsa}"
APP_AUTH="${APP_AUTH:-${APP_SSH}/authorized_keys}"

groupadd -g ${APP_GID} ${APP_USER}
useradd -u ${APP_UID} -g ${APP_GID} ${APP_USER}

if [ -n "${APP_SUDO}" ]; then
    echo "${APP_SUDO} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
fi

mkdir -p ${APP_SSH}
if [ -f "${APP_KEY}" ]; then
    cp ${APP_KEY} ${APP_KEY}
    ssh-keygen -y -f ${APP_KEY} > ${APP_AUTH}
fi

chown -R ${APP_USER}:${APP_USER} ${APP_HOME}

