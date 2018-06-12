FROM debian
MAINTAINER André Bauer <monotek23@gmail.com>

ARG DEBIAN_FRONTEND=noninteractive

# install proftpd
RUN apt-get update && \
    apt-get -y install proftpd

# cleanup
RUN rm -rf /var/lib/apt/lists/* preseed.txt

# fixing service start
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# docker init
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
