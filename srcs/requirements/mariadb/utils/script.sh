#!/bin/bash

sed -i 's!#port!port !g' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's!127.0.0.1!0.0.0.0!g' /etc/mysql/mariadb.conf.d/50-server.cnf

service mysql start 

mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB ;"
mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PWD' ;"
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USR'@'%' ;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ADMIN_PWD' ;"
mysql -u root -p$ADMIN_PWD -e "FLUSH PRIVILEGES;"
