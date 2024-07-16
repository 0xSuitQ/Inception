#!/bin/bash

mkdir -p /var/www/html
cd /var/www/html
rm -rf ./*

sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

wp core download --allow-root

mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
mv /wp-config.php /var/www/html/wp-config.php

# sed -i -r "s/database_name_here/$MYSQL_DB/"   wp-config.php
# sed -i -r "s/username_here/$MYSQL_USR/"  wp-config.php
# sed -i -r "s/password_here/$MYSQL_PWD/"    wp-config.php
# sed -i -r "s/localhost/$MYSQL_HOSTNAME/"    wp-config.php

wp core install --url=$DOMAIN_NAME/ --title=$TITLE --admin_user=$ADMIN_USR --admin_password=$ADMIN_PWD --admin_email=$ADMIN_EMAIL --skip-email --allow-root

wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root

wp theme install neve --allow-root
wp theme activate neve --allow-root

mkdir /run/php

/usr/sbin/php-fpm7.4 -F