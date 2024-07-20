#!/bin/bash

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
	-subj "/C=CZ/L=PR/O=42/OU=cadet/CN=nandroso.42.fr"

echo "
server {
	listen 443 ssl;
	listen [::]:443 ssl;

	server_name www.nandroso.42.fr nandroso.42.fr;

	ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
	ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;

	ssl_protocols TLSv1.3;

	index index.php;
    root /var/www/html;

	location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

	location ~ [^/]\.php(/|$) {
        fastcgi_pass wordpress:9000;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }

}" > /etc/nginx/sites-available/default

nginx -g "daemon off;"
