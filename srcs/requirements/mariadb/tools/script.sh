#!/bin/bash

sed -i 's!#port!port !g' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's!127.0.0.1!0.0.0.0!g' /etc/mysql/mariadb.conf.d/50-server.cnf


mysqld_safe &

while ! mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PWD --silent; do
    sleep 1
done

if ! mysql -u root -p$MYSQL_ROOT_PWD -e "USE $MYSQL_DB;" &> /dev/null
then
	mysql -u root -p$MYSQL_ROOT_PWD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB ;"
	mysql -u root -p$MYSQL_ROOT_PWD -e "CREATE USER IF NOT EXISTS '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PWD' ;"
	mysql -u root -p$MYSQL_ROOT_PWD -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USR'@'%'; "
	mysql -u root -p$MYSQL_ROOT_PWD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD' ;"
	mysql -u root -p$MYSQL_ROOT_PWD -e "FLUSH PRIVILEGES;"
fi

mysqladmin -u root -p$MYSQL_ROOT_PWD shutdown


mysqld_safe