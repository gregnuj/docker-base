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
        ssh \
        openssl \
        socat \
        sudo \
        supervisor \
        vim \
        wget \
	--no-install-recommends \
	&& rm -r /var/lib/apt/lists/*

# Setup user
RUN /usr/sbin/adduser --disabled-password --uid 999 --gid 10 --shell /bin/bash cyclops && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

ENV SHELL=/bin/bash \
    EDITOR=/usr/local/bin/vim

USER cyclops
WORKDIR /home/cyclops
CMD ["/bin/bash", "-l"]
