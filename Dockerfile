FROM alpine:3.7


LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

# Install packages
RUN apk add --no-cache \
        sudo \
        bash \
        curl \
        git \
        openssl \
        supervisor \
        vim

CMD ["/usr/bin/bash"]
