#!/bin/bash

service mysql start 

mysql -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB ;"
mysql -e "CREATE USER IF NOT EXISTS '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PWD' ;"
mysql -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USR'@'%' ;"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$ADMIN_PWD' ;"
mysql -u root -p$ADMIN_PWD -e "FLUSH PRIVILEGES;"