
LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

FROM ubuntu:16.04

# Update existing packages.
RUN apt-get update 

# Ensure UTF-8
RUN locale-gen en_US.UTF-8 && \
    dpkg-reconfigure locales && \
    export LC_ALL=en_US.UTF-8 && \
    export LANGUAGE=en_US.UTF-8 && \
    export LANG=en_US.UTF-8

# Install packages
RUN DEBIAN_FRONTEND=noninteractive \
    apt-get -y install \
        bash \
        curl \
        git \
        openssl \
        supervisor \
        vim
RUN apt-get -y clean

CMD ["/run.sh"]
