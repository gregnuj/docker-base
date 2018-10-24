FROM debian:stretch-slim
LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"
USER root

# To enable build behind proxy
ARG http_proxy

# Install packages
RUN set -ex \
    && apt-get update \
    && apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    cron \
    dnsutils \
    gettext \
    git \
    gnupg2 \
    openjdk \
    openssl \
    socat \
    ssh \
    sudo \
    supervisor \
    telnet \
    unzip \
    vim \
    wget \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

RUN set -ex \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && curl -sS https://packages.sury.org/php/apt.gpg > /etc/apt/trusted.gpg.d/php.gpg \ 
    && echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list \
    && apt-get update \
    && apt-get install -y \
    nodejs \
    php7.2 \
    php7.2-json \
    yarn \
    --no-install-recommends \
    && rm -r /var/lib/apt/lists/*

# add files in rootfs
ADD ./rootfs /

# Set Root to bash not ash and overwrite .bashrc
RUN set -ex \
    && sed -i 's/root:\/bin\/ash/root:\/bin\/bash/' /etc/passwd \
    && cp /etc/skel/.bashrc /root/.bashrc \
    && mkdir -p /var/log/supervisord \
    && mkdir -p /var/run/sshd

# Setup environment
    ENV SHELL="/bin/bash" \
    EDITOR="/usr/local/bin/vim" \
    # defaults to 'cyclops'
    APP_USER=""  \ 
    # defaults to random
    APP_PASSWD=""  \ 
    # defaults to 10000
    APP_UID="" \
    # defaults to $APP_USER
    APP_GROUP="" \ 
    # defaults to $APP_USER
    APP_SUDO=""  \ 
    # defaults to $APP_UID
    APP_GID=""   \ 
    # defaults to /home/$APP_USER
    APP_HOME=""  \ 
    # defaults to /home/$APP_USER/.ssh
    APP_SSH=""   \ 
    # defaults to /home/$APP_USER/.ssh/id_rsa
    APP_KEY=""   \ 
    # defaults to /home/$APP_USER/.ssh/authorized_keys
    APP_AUTH="" \   
    # install adminer
    HTDOCS_DIR="/var/www/localhost/htdocs" \   
    # install adminer
    ADMINER_INSTALL="" \
    ADMINER_DIR="/var/www/localhost/htdocs/adminer" \
    # install codiad
    CODIAD_INSTALL="" \
    CODIAD_DIR="/var/www/localhost/htdocs/codiad" \
    # install webconsole
    WEBCONSOLE_INSTALL="" \
    WEBCONSOLE_DIR="/var/www/localhost/htdocs/webconsole"

EXPOSE 22 8000 9001
VOLUME ["/var/www/localhost/htdocs"]
WORKDIR "/var/www/localhost/htdocs"
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor.d/default.ini"]
