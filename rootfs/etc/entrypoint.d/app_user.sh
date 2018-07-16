#!/bin/bash

APP_USER="${APP_USER:-cyclops}"
APP_GROUP="${APP_GROUP:-${APP_USER}}"
APP_SUDO="${APP_SUDO:-${APP_USER}}"
APP_UID="${APP_UID:-10000}"
APP_GID="${APP_GID:-${APP_UID}}"
APP_HOME="${APP_HOME:-/home/${APP_USER}}"
APP_SSH="${APP_SSH:-${APP_HOME}/.ssh}"
APP_KEY="${APP_KEY:-${APP_SSH}/id_rsa}"
APP_AUTH="${APP_AUTH:-${APP_SSH}/authorized_keys}"

addgroup -g ${APP_GID} ${APP_USER}
adduser -D -u ${APP_UID} -G ${APP_USER} ${APP_USER}

echo "${APP_SUDO} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
echo "exec sudo -u "${APP_USER}" bash -l" >> /root/.profile

mkdir -p ${APP_SSH}
if [ -f "${APP_KEY}" ]; then
    cp ${APP_KEY} ${APP_KEY}
    ssh-keygen -y -f ${APP_KEY} > ${APP_AUTH}
else
    ssh-keygen -q -t rsa -N '' -f ${APP_KEY}
    cp ${APP_KEY}.pub ${APP_AUTH}
fi

chown -R ${APP_USER}:${APP_USER} ${APP_HOME}
