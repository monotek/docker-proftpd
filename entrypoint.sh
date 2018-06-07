#!/bin/bash

set -e

FTP_DIR="${FTP_DIR:=/ftp}"
FTP_PASS="${FTP_PASS:=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c10)}"
FTP_USER="${FTP_USER:=ftpuser}"
FTP_TIMEOUT="${FTP_TIMEOUT:=infinity}"
FTP_PORT_CONTROL="${FTP_PORT_CONTROL:=21}"

echo -e "Creating user ${FTP_USER} with home dir ${FTP_DIR}\n"
useradd -m -d ${FTP_DIR} -k /noskel ${FTP_USER} -s /bin/bash

echo -e "Set ${FTP_USER} password to ${FTP_PASS}\n"
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

echo -e "Changing proftpd.conf\n"
sed -i /etc/proftpd/proftpd.conf -e 's/# DefaultRoot/DefaultRoot/' -e "s/Port\s*21/Port ${FTP_PORT_CONTROL}/" -e 's#/var/log.*#/dev/stdout#g'

if [ -n "${FTP_PORTS_DATA_BEG}" ] && [ -n "${FTP_PORTS_DATA_END}" ]; then
  sed -i /etc/proftpd/proftpd.conf -e "s/# PassivePorts.*/PassivePorts ${FTP_PORTS_DATA_BEG} ${FTP_PORTS_DATA_END}/"
fi

echo -e "fixing directory rights\n"
chown -R ${FTP_USER}:${FTP_USER} ${FTP_DIR}

echo -e "Starting ftp service on port 8021... will exit in ${FTP_TIMEOUT} seconds... \n"
service proftpd start

while true; do
  sleep ${FTP_TIMEOUT}
  echo -e "\n Timeout reached... Stopping ftp process but keep container alive... \n"
  service proftpd stop
done
