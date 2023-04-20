#!/bin/bash
if [ ! -d "/var/lib/mysql/${DB_NAME}" ]
then
	#Create socket for mysql (to run sql)
	service mysql start
	sleep 3
	#mysql -e = run command without opening mysql
	mysql -e "CREATE DATABASE ${DB_NAME}" && \
	mysql -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}';" && \
	mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%' IDENTIFIED BY '${DB_USER_PASSWORD}' WITH GRANT OPTION;" && \
	mysql -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_USER_PASSWORD}' WITH GRANT OPTION;" && \
	mysql -e "FLUSH PRIVILEGES;"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}'"
	sed -i "s/password =/password = ${DB_ROOT_PASSWORD} #/" /etc/mysql/debian.cnf
	service mysql stop
fi

#start mysql server in safe mode (will restart if crash) and send data to path
mysqld_safe --datadir=/var/lib/mysql