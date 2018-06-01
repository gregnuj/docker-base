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

ENV SHELL=/bin/bash \
    EDITOR=/usr/local/bin/vim

CMD ["/bin/bash"]
