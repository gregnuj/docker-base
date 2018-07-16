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
        git \
        gnupg2 \
        openssl \
        socat \
        ssh \
        sudo \
        supervisor \
        telnet \
        vim \
        wget \
	--no-install-recommends \
	&& rm -r /var/lib/apt/lists/*

# add files in rootfs
ADD ./rootfs /

# Set Root to bash not ash and overwrite .bashrc
RUN sed -i 's/root:\/bin\/ash/root:\/bin\/bash/' /etc/passwd && \
    cp /etc/skel/.bashrc /root/.bashrc

# Setup environment
ENV SHELL="/bin/bash" \
    EDITOR="/usr/local/bin/vim" \
    APP_UID="10000" \
    # defaults to user
    APP_SUDO=""  \ 
    # defaults to user
    APP_GROUP="" \ 
    # defaults to UID
    APP_GID=""   \ 
    # defaults to /home/$USER
    APP_HOME=""  \ 
    # defaults to /home/$APP_USER/.ssh
    APP_SSH=""   \ 
    # defaults to /home/$APP_USER/.ssh/id_rsa
    APP_KEY=""   \ 
    # defaults to /home/$APP_USER/.ssh/authorized_keys
    APP_AUTH=""    

WORKDIR /home/cyclops
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-n"]
