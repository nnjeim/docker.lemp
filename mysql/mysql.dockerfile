FROM mysql/mysql-server

COPY ./conf/my.cnf /etc/my.cnf
COPY ./cmd/grant.sh /root/grant.sh
