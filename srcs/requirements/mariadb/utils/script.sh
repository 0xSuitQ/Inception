#!/bin/bash

sed -i 's!#port!port !g' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -i 's!127.0.0.1!0.0.0.0!g' /etc/mysql/mariadb.conf.d/50-server.cnf

# Start MySQL service
mysqld_safe &

while ! mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PWD --silent; do
    sleep 1
done

# Check if MySQL server is running
if mysqladmin ping -h localhost -u root -p$MYSQL_ROOT_PWD
then
    # Create the database and user
    mysql -u root -p$MYSQL_ROOT_PWD -e "CREATE DATABASE IF NOT EXISTS $MYSQL_DB ;"
    mysql -u root -p$MYSQL_ROOT_PWD -e "CREATE USER IF NOT EXISTS '$MYSQL_USR'@'%' IDENTIFIED BY '$MYSQL_PWD' ;"
    mysql -u root -p$MYSQL_ROOT_PWD -e "GRANT ALL PRIVILEGES ON $MYSQL_DB.* TO '$MYSQL_USR'@'%'; "
    mysql -u root -p$MYSQL_ROOT_PWD -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD' ;"
    mysql -u root -p$MYSQL_ROOT_PWD -e "FLUSH PRIVILEGES;"

    # Stop MySQL service
    mysqladmin -u root -p$MYSQL_ROOT_PWD shutdown

    # # Start MySQL daemon
    mysqld_safe
else
    echo "MySQL server is not running or root password is incorrect"
fi