FROM debian:11

RUN apt update -y && \
	apt install -y mariadb-server

# RUN mkdir -p /var/run/mysqld \
# && chown -R mysql:mysql /var/run/mysqld \
# && chmod 777 /var/run/mysqld

COPY ./tools/50-server.cnf /etc/mysql/mariadb.conf.d/

COPY ./tools/script.sh /

RUN chmod +x /script.sh

ENTRYPOINT [ "/script.sh" ]