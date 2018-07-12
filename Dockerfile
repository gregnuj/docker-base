FROM alpine:3.8
LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"
USER root

# To enable build behind proxy
ARG http_proxy

# Install packages
RUN set -ex \
        && apk add --no-cache \
        bash \
        curl \
        git \
        libice \
        libsm \
        libx11 \
        libxt \
        ncurses \
        openssl \
        openssh \
        socat \
        sudo \
        supervisor \
        wget

# get vim from jare/alpine-vim (uses alpine:latest)
COPY --from=jare/alpine-vim /usr/local/bin/ /usr/local/bin
COPY --from=jare/alpine-vim /usr/local/share/vim/ /usr/local/share/vim/

ADD ./rootfs /

# Set Root to bash not ash and overwrite .bashrc
RUN sed -i 's/root:\/bin\/ash/root:\/bin\/bash/' /etc/passwd && \
    cp /etc/skel/.bashrc /root/.bashrc

# Setup user
ENV SHELL="/bin/bash" \
    EDITOR="/usr/local/bin/vim"
    APP_ID="10000"
    APP_USER="cyclops"
    APP_HOME="/home/cyclops"
    APP_SSH="/home/cyclops/.ssh"
    APP_KEY="/home/cyclops/.ssh/id_rsa"
    APP_AUTH="/home/cyclops/.ssh/authorized_keys"


WORKDIR /home/cyclops
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

