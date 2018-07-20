#!/bin/bash

export APP_USER="${APP_USER:-cyclops}"
export APP_GROUP="${APP_GROUP:-${APP_USER}}"
export APP_SUDO="${APP_SUDO:-${APP_USER}}"
export APP_UID="${APP_UID:-10000}"
export APP_GID="${APP_GID:-${APP_UID}}"
export APP_HOME="${APP_HOME:-/home/${APP_USER}}"
export APP_SSH="${APP_SSH:-${APP_HOME}/.ssh}"
export APP_KEY="${APP_KEY:-${APP_SSH}/id_rsa}"
export APP_AUTH="${APP_AUTH:-${APP_SSH}/authorized_keys}"

groupadd -g ${APP_GID} ${APP_USER}
useradd -u ${APP_UID} -g ${APP_GID} ${APP_USER}

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

