#!/bin/bash

set -e

FTP_DIR="${FTP_DIR:=/ftp}"
FTP_PASS="${FTP_PASS:=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c10)}"
FTP_USER="${FTP_USER:=ftpuser}"
FTP_TIMEOUT="${FTP_TIMEOUT:=infinity}"
FTP_PORT_CONTROL=${FTP_PORT_CONTROL:=21}
FTP_PORTS_DATA=${FTP_PORTS_DATA}

echo -e "Creating user ${FTP_USER} with home dir ${FTP_DIR}\n"
useradd -m -d ${FTP_DIR} -k /noskel ${FTP_USER} -s /bin/bash

echo -e "Set user password to ${FTP_PASS}\n"
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

echo -e "Changing proftpd.conf\n"
sed -i /etc/proftpd/proftpd.conf -e 's/# DefaultRoot/DefaultRoot/' -e "s/Port\s*21/Port ${FTP_PORT_CONTROL}/"

if [ -n "${FTP_PORTS_DATA}" ]; then
  sed -i /etc/proftpd/proftpd.conf -e "s/# PassivePorts.*/PassivePorts ${FTP_PORTS_DATA}/"
fi  

echo -e "Starting ftp service on port 8021... will exit in ${FTP_TIMEOUT} seconds... \n"
service proftpd start

while true; do
  sleep ${FTP_TIMEOUT}
  echo -e "\n Timeout reached... Stopping ftp process but keep container alive... \n"
  service proftpd stop
done
