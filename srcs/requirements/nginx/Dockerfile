FROM debian:11

RUN apt update -y && \
	apt install -y nginx \
	&& apt install -y openssl

COPY ./index.html /var/www/html

# COPY ./conf/default /etc/nginx/sites-available

COPY ./tools/script.sh /

RUN chmod +x /script.sh

ENTRYPOINT ["/script.sh"]