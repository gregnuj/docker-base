FROM alpine:3.7

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

# Install packages
RUN apk add --no-cache \
        sudo \
        bash \
        curl \
        git \
        libice \
        libsm \
        libx11 \
        libxt \
        ncurses \
        openssl \
        sudo \
        supervisor

# get vim from jare/alpine-vim (uses alpine:latest)
COPY --from=jare/alpine-vim /usr/local/bin/ /usr/local/bin
COPY --from=jare/alpine-vim /usr/local/share/vim/ /usr/local/share/vim/

# Set Root to bash not ash and overwrite .bashrc
RUN sed -i 's/root:\/bin\/ash/root:\/bin\/bash/' /etc/passwd && \
    cp /etc/skel/.bashrc /root/.bashrc

# Setup user
RUN /usr/sbin/adduser -D -G wheel -k /etc/skel -s /bin/bash user && \
    echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

USER user
WORKDIR /home/user

ENV SHELL=/bin/bash \
    EDITOR=/usr/local/bin/vim

CMD ["/bin/bash"]
