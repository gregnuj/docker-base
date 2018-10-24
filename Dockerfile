FROM alpine:edge
LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"
USER root

# To enable build behind proxy
ARG http_proxy

# Install packages
RUN set -ex \
    && apk add --no-cache \
    bash \
    bind-tools \
    busybox-extras \
    curl \
    gettext \
    git \
    less \
    libice \
    libsm \
    libx11 \
    libxt \
    ncurses \
    nmap \
    nodejs \
    openjdk8 \
    #openssl \
    openssh \
    php7 \
    php7-json \
    rsync \
    socat \
    sudo \
    supervisor \
    unzip \
    vim \
    wget \
    yarn 

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
