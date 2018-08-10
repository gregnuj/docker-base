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


if [ "${APP_UID}" -lt 256000 ]; then
    addgroup -g ${APP_GID} ${APP_USER}
    adduser -D -u ${APP_UID} -G ${APP_USER} ${APP_USER}
else 
    # Create user https://stackoverflow.com/questions/41807026/cant-add-a-user-with-a-high-uid-in-docker-alpine
    echo "${APP_USER}:x:${APP_UID}:${APP_GID}::${APP_HOME}:" >> /etc/passwd
    echo "${APP_USER}:!:$(($(date +%s) / 60 / 60 / 24)):0:99999:7:::" >> /etc/shadow
    echo "${APP_GROUP}:x:${APP_GID}:" >> /etc/group
    cp /etc/skel ${APP_HOME} && chown -R ${APP_USER}:${APP_GROUP} ${APP_HOME}
fi

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

# needed for setup.ini
chown -R ${APP_USER}:${APP_USER} /var/www
chown -R ${APP_USER}:${APP_USER} ${APP_HOME}

