FROM debian:stretch-slim

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

# To enable build behind proxy
ARG http_proxy

# Install packages
RUN set -ex \
	&& apt-get update \
	&& apt-get install -y \
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

CMD ["/bin/bash"]
