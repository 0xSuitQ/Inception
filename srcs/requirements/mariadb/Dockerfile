FROM debian:11

RUN apt update -y && \
	apt install -y mariadb-server

COPY ./utils/script.sh /

RUN chmod +x /script.sh

ENTRYPOINT [ "/script.sh" ]