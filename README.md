# proftpd server

with configurable username, password, home dir & optional exit time in seconds

docker run -it -p 8021:8021 -e FTP_USER=bla -e FTP_PASS=bla -e FTP_DIR=/bla -e FTP_TIMEOUT=1200 docker.kiwigrid.com/ops/ftpserver
