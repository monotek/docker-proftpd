FROM debian
<<<<<<< HEAD
MAINTAINER André Bauer <andre.bauer@kiwigrid.com>
=======
MAINTAINER André Bauer <monotek23@gmail.com>
>>>>>>> monotek/master

ARG DEBIAN_FRONTEND=noninteractive

# Expose ports
EXPOSE 8021

# install proftpd
RUN apt-get update && \
    apt-get -y install proftpd

# cleanup
RUN rm -rf /var/lib/apt/lists/* preseed.txt

<<<<<<< HEAD
# changin proftpd.conf
RUN sed -i /etc/proftpd/proftpd.conf -e 's/Port\s*21/Port 8021/' -e 's/# DefaultRoot/DefaultRoot/'

=======
>>>>>>> monotek/master
# fixing service start
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

# docker init
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
