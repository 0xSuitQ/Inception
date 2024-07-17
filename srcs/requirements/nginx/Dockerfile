FROM debian:11

RUN apt update -y && \
	apt install -y nginx \
	&& apt install -y openssl

# COPY ./conf/default /etc/nginx/sites-available

COPY ./utils/script.sh /

RUN chmod +x /script.sh

ENTRYPOINT ["/script.sh"]