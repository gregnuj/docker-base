#!/bin/bash

export APP_UID="${APP_UID:-10000}"
export APP_GID="${APP_GID:-${APP_UID}}"
export APP_USER="${APP_USER:-cyclops}"
export APP_HOME="${APP_HOME:-/home/${APP_USER}}"
export APP_GROUP="${APP_GROUP:-${APP_USER}}"
export APP_SUDO="${APP_SUDO:-${APP_USER}}"
export APP_SSH="${APP_SSH:-${APP_HOME}/.ssh}"
export APP_KEY="${APP_KEY:-${APP_SSH}/id_rsa}"
export APP_AUTH="${APP_AUTH:-${APP_SSH}/authorized_keys}"
export APP_SECRET="${APP_SECRET:-/var/run/secrets/app_password}"


TAG="$(basename $0 '.sh')"

echo "${TAG}: Creating user ${APP_USER} (${APP_UID}) in group ${APP_GROUP} (${APP_GID})"
if [ "${APP_UID}" -lt 256000 ]; then
    addgroup -g ${APP_GID} ${APP_GROUP}
    adduser -D -u ${APP_UID} -G ${APP_USER} ${APP_USER}
else 
    # Create user https://stackoverflow.com/questions/41807026/cant-add-a-user-with-a-high-uid-in-docker-alpine
    echo "${APP_USER}:x:${APP_UID}:${APP_GID}::${APP_HOME}:" >> /etc/passwd
    echo "${APP_USER}:!:$(($(date +%s) / 60 / 60 / 24)):0:99999:7:::" >> /etc/shadow
    echo "${APP_GROUP}:x:${APP_GID}:" >> /etc/group
    cp /etc/skel ${APP_HOME} && chown -R ${APP_USER}:${APP_GROUP} ${APP_HOME}
fi

# Get/change passwd (for sudo)
if [ -z "${APP_PASSWD}" ]; then
    # Create password if it does not exist
    if [ ! -f "${APP_SECRET}" ]; then
        mkdir -p "$(dirname ${APP_SECRET})"
        openssl rand -base64 10 > ${APP_SECRET}
    fi
    APP_PASSWD="$(echo -n $(cat ${APP_SECRET}))"
fi
echo "${TAG}: Setting password for ${APP_USER}"
echo "${APP_USER}:${APP_PASSWD}" | chpasswd

# update sudoers
echo "${TAG}: Adding sudo for ${APP_SUDO}"
echo "${APP_SUDO} ALL=(ALL) ALL" >> /etc/sudoers


echo "${TAG}: Adding ssh key in ${APP_SSH}"
mkdir -p ${APP_SSH}
if [ -f "${APP_KEY}" ]; then
    cp ${APP_KEY} ${APP_SSH}/$(basename ${APP_KEY})
    chmod 400 ${APP_SSH}/$(basename ${APP_KEY})
    ssh-keygen -y -f ${APP_KEY} > ${APP_AUTH}
else
    ssh-keygen -q -t rsa -N '' -f ${APP_KEY}
    cp ${APP_KEY}.pub ${APP_AUTH}
fi

# needed for setup.ini
echo "${TAG}: Setting ownership for ${APP_HOME}"
chown -R ${APP_USER}:${APP_USER} ${APP_HOME}

# use APP_HOME as HOME
export HOME="${APP_HOME}"
