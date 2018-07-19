FROM alpine:edge
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
        git \
        libice \
        libsm \
        libx11 \
        libxt \
        ncurses \
        nmap \
        gnupg2 \
        #openssl \
        openssh \
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

# add files in rootfs
ADD ./rootfs /

# Set Root to bash not ash and overwrite .bashrc
RUN sed -i 's/root:\/bin\/ash/root:\/bin\/bash/' /etc/passwd \
    && cp /etc/skel/.bashrc /root/.bashrc \
    && mkdir -p /var/run/sshd

# Setup environment
ENV SHELL="/bin/bash" \
    EDITOR="/usr/local/bin/vim" \
    # defaults to 'cyclops'
    APP_USER=""  \ 
    # defaults to 10000
    APP_UID="" \
    # defaults to $APP_USER
    APP_GROUP="" \ 
    # defaults to $APP_UID
    APP_SUDO=""  \ 
    # defaults to $APP_USER
    APP_GID=""   \ 
    # defaults to /home/$APP_USER
    APP_HOME=""  \ 
    # defaults to /home/$APP_USER/.ssh
    APP_SSH=""   \ 
    # defaults to /home/$APP_USER/.ssh/id_rsa
    APP_KEY=""   \ 
    # defaults to /home/$APP_USER/.ssh/authorized_keys
    APP_AUTH=""    

EXPOSE 22
WORKDIR /home/cyclops
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
