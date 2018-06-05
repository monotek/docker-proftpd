#!/bin/bash

set -e

FTP_DIR="${FTP_DIR:=/ftp}"
FTP_PASS="${FTP_PASS:=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c10)}"
FTP_USER="${FTP_USER:=ftpuser}"
FTP_TIMEOUT="${FTP_TIMEOUT:=infinity}"

echo -e "Creating user ${FTP_USER} with home dir ${FTP_DIR}\n"
useradd -m -d ${FTP_DIR} -k /noskel ${FTP_USER} -s /bin/bash

echo -e "set user password to ${FTP_PASS}\n"
echo "${FTP_USER}:${FTP_PASS}" | chpasswd

echo -e "Starting ftp service on port 8021... will exit in ${FTP_TIMEOUT} seconds... \n"
service proftpd start

while true; do
  sleep ${FTP_TIMEOUT}
  echo -e "\n Timeout reached... Exiting... \n"
  exit 0
done
