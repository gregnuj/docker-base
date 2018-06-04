FROM debian:stretch-slim

LABEL MAINTAINER="Greg Junge <gregnuj@gmail.com>"

# Install packages
# persistent / runtime deps
RUN apt-get update && apt-get install -y \
                git \
		curl \
                vim \
                supervisor
	--no-install-recommends && rm -r /var/lib/apt/lists/*

CMD ["/bin/bash"]
