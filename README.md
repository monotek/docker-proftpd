# proftpd server

with configurable username, password, home dir & optional exit time in seconds

docker run --rm -it -p 21:21 -e FTP_USER=bla -e FTP_PASS=bla -e FTP_DIR=/bla -e FTP_TIMEOUT=1200 -e FTP_PORT_CONTROL=21 -v /bla:/bla monotek/docker-proftpd
