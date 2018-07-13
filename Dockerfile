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
        git \
        gnupg2 \
        openssl \
        socat \
        ssh \
        sudo \
        supervisor \
        vim \
        wget \
	--no-install-recommends \
	&& rm -r /var/lib/apt/lists/*

# Add files
ADD ./rootfs /

# Set Root to bash not ash and overwrite .bashrc
RUN sed -i 's/root:\/bin\/ash/root:\/bin\/bash/' /etc/passwd && \
    cp /etc/skel/.bashrc /root/.bashrc

# Setup user
ENV SHELL="/bin/bash" \
    EDITOR="/usr/local/bin/vim" \
    APP_UID="10000" \
    APP_GID="10000" \
    APP_USER="cyclops" \
    APP_SUDO="cyclops" \
    APP_HOME="/home/cyclops" \
    APP_SSH="/home/cyclops/.ssh" \
    APP_KEY="/home/cyclops/.ssh/id_rsa" \
    APP_AUTH="/home/cyclops/.ssh/authorized_keys"

WORKDIR /home/cyclops
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

