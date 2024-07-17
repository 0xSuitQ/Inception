FROM debian:11

RUN apt update -y && \
	apt install php7.4-fpm curl php-mysql -y

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
	&& chmod +x wp-cli.phar \
	&& mv wp-cli.phar /usr/local/bin/wp

COPY ./utils/script.sh /


RUN chmod +x /script.sh && \
    mkdir -p /var/www/html && \
    chown -R www-data:www-data /var/www/html

ENTRYPOINT ["/script.sh"]