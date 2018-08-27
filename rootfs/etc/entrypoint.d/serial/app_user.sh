#!/bin/bash

# if container is run as a specific user then create that user/group
export APP_UID="$(id -u)"
export APP_GID="$(id -g)"
if [ $(id -u) == 0 ]; then
   export APP_USER="root"
   export APP_GROUP="root"
   export APP_SUDO=""
   export APP_HOME="${APP_HOME:-/root}"
else
   export APP_USER="${APP_USER:-cyclops}"
   export APP_GROUP="${APP_GROUP:-${APP_USER}}"
   export APP_SUDO="${APP_SUDO:-${APP_USER}}"
   export APP_HOME="${APP_HOME:-/home/${APP_USER}}"
fi
export APP_SSH="${APP_SSH:-${APP_HOME}/.ssh}"
export APP_KEY="${APP_KEY:-${APP_SSH}/id_rsa}"
export APP_AUTH="${APP_AUTH:-${APP_SSH}/authorized_keys}"


TAG="$(basename $0 '.sh')"

if [ ${APP_UID} -gt 0 ]; then
    echo "${TAG}: Creating user ${APP_USER} (${APP_UID}) in group ${APP_GROUP} (${APP_GID})"
    if [ "${APP_UID}" -lt 256000 ]; then
        [ $id -u ${$APP_USER} ] || addgroup -g ${APP_GID} ${APP_USER}
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
        if [ -f "${APP_SECRET}" ]; then
           openssl rand -base64 10 > ${APP_SECRET}
        fi
        APP_PASSWD="$(echo -n $(cat ${APP_SECRET}))"
    fi
    echo "${TAG}: Setting password for ${APP_USER}"
    echo "${APP_USER}:${APP_PASSWD}" | chpasswd

    # update sudoers
    echo "${TAG}: Adding sudo for ${APP_SUDO}"
    echo "${APP_SUDO} ALL=(ALL) ALL" >> /etc/sudoers
fi


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