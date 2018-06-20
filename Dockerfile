FROM alpine:3.7

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

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

ADD ./bashrc /etc/bash.bashrc
ADD ./bashrc /etc/skel/.bashrc
ADD ./profile /etc/profile
ADD ./motd /etc/motd

# Set Root to bash not ash and overwrite .bashrc
RUN sed -i 's/root:\/bin\/ash/root:\/bin\/bash/' /etc/passwd && \
    cp /etc/skel/.bashrc /root/.bashrc

# Setup user
RUN /usr/sbin/adduser -D -u 100 -G wheel -s /bin/bash cyclops && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER cyclops

ENV SHELL=/bin/bash \
    EDITOR=/usr/local/bin/vim

WORKDIR /home/cyclops
ENTRYPOINT ["/bin/bash"]
CMD ["-l"]
