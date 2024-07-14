#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \ 
	-keyout /etc/ssl/private/nginx-selfsigned.key \
	-out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=CZ/L=PR/O=42/OU=cadet/CN=[nandroso.42.fr](http://nandroso.42.fr/)"

echo "
server {
	listen 443 ssl;
	listen [::]:443 ssl;

	server_name www.nandroso.42.fr nandroso.42.fr;

	ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
	ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

	ssl_protocols TLSv1.3;

	root /var/www/html;
	index index.html;

	location ~ [^/]\\.php(/|$) {
	try_files $uri =404;
	fastcgi_pass wordpress:9000;
	include fastcgi_params;
	fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
	}
}" > /etc/nginx/sites-available/default

nginx -g "daemon off;"
