#!/bin/bash


cd /var/www/html
# chmod u+w /var/www/html
# chown $USER /var/www/html

if [ -f "/var/www/html/wp-config.php" ]
then
    echo "WordPress already installed"
else

    sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/g' /etc/php/7.4/fpm/pool.d/www.conf

    wp core download --allow-root

    mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
    mv /wp-config.php /var/www/html/wp-config.php

    awk -v db="$MYSQL_DB" '/DB_NAME/ {$0="define( '\''DB_NAME'\'', '\''" db "'\'' );"}1' wp-config.php > tmp && mv tmp wp-config.php
    awk -v usr="$MYSQL_USR" '/DB_USER/ {$0="define( '\''DB_USER'\'', '\''" usr "'\'' );"}1' wp-config.php > tmp && mv tmp wp-config.php
    awk -v pwd="$MYSQL_PWD" '/DB_PASSWORD/ {$0="define( '\''DB_PASSWORD'\'', '\''" pwd "'\'' );"}1' wp-config.php > tmp && mv tmp wp-config.php
    awk -v host="$MYSQL_HOSTNAME" '/DB_HOST/ {$0="define( '\''DB_HOST'\'', '\''" host "'\'' );"}1' wp-config.php > tmp && mv tmp wp-config.php

    wp core install --url=$DOMAIN_NAME/ --title=$TITLE --admin_user=$ADMIN_USR --admin_password=$ADMIN_PWD --admin_email=$ADMIN_EMAIL --skip-email --allow-root

    wp user create $WP_USR $WP_EMAIL --role=author --user_pass=$WP_PWD --allow-root

    wp theme delete twentytwentytwo twentytwentythree --allow-root

	wp post delete $(wp post list --post_type='post' --name=hello-world --format=ids --allow-root) --force --allow-root
	wp post delete $(wp post list --post_type='page' --name=sample-page --format=ids --allow-root) --force --allow-root
	wp post create --post_type=page --post_status=publish --post_title="Home" --comment_status=open --allow-root
	wp post create --post_type=page --post_status=publish --post_title="Articles" --allow-root

	wp option update show_on_front page --allow-root
	wp option update page_on_front $(wp post list --post_type='page' --name=home --format=ids --allow-root) --allow-root
	wp option update page_for_posts $(wp post list --post_type='page' --name=articles --format=ids --allow-root) --allow-root

	CUSTOM_PAGE_CONTENT="<!-- wp:paragraph -->
		<p>Comment section</p>
		<!-- /wp:paragraph -->

		<!-- wp:paragraph -->
		<p>Feel free to leave a comment below and engage with our community.</p>
		<!-- /wp:paragraph -->

		<!-- wp:comments -->
		<div class=\"wp-block-comments\"><!-- wp:comments-title /-->

		<!-- wp:comment-template -->
		<!-- wp:columns -->
		<div class=\"wp-block-columns\"><!-- wp:column {\"width\":\"40px\"} -->
		<div class=\"wp-block-column\" style=\"flex-basis:40px\"><!-- wp:avatar {\"size\":40,\"style\":{\"border\":{\"radius\":\"20px\"}}} /--></div>
		<!-- /wp:column -->

		<!-- wp:column -->
		<div class=\"wp-block-column\"><!-- wp:comment-author-name {\"fontSize\":\"small\"} /-->

		<!-- wp:group {\"style\":{\"spacing\":{\"margin\":{\"top\":\"0px\",\"bottom\":\"0px\"}}},\"layout\":{\"type\":\"flex\"}} -->
		<div class=\"wp-block-group\" style=\"margin-top:0px;margin-bottom:0px\"><!-- wp:comment-date {\"fontSize\":\"small\"} /-->

		<!-- wp:comment-edit-link {\"fontSize\":\"small\"} /--></div>
		<!-- /wp:group -->

		<!-- wp:comment-content /-->

		<!-- wp:comment-reply-link {\"fontSize\":\"small\"} /--></div>
		<!-- /wp:column --></div>
		<!-- /wp:columns -->
		<!-- /wp:comment-template -->

		<!-- wp:comments-pagination -->
		<!-- wp:comments-pagination-previous /-->

		<!-- wp:comments-pagination-numbers /-->

		<!-- wp:comments-pagination-next /-->
		<!-- /wp:comments-pagination -->

		<!-- wp:post-comments-form /--></div>
		<!-- /wp:comments -->"

    wp post create --post_type=page --post_title='Comment section' --post_content="$CUSTOM_PAGE_CONTENT" --post_status=publish --comment_status=open --allow-root

	wp rewrite structure '/%postname%/' --allow-root

fi

mkdir -p /run/php

/usr/sbin/php-fpm7.4 -F