FROM ubuntu:16.04

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

# Update existing packages.
RUN apt-get update 

# Set the environment variable for package install
ENV DEBIAN_FRONTEND noninteractive

# Install packages
RUN apt-get -y install \
        curl \
        git \
        openssl \
        supervisor \
        vim
RUN apt-get -y clean

# Set vim as default editor
RUN update-alternatives --install /usr/bin/editor editor /usr/bin/vim 100
