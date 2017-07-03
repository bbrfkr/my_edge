#!/bin/sh

mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR -e "show databases;" | grep "keystone"
if [ $? -ne 0 ] ; then
  mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR mysql <<EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DB_PASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DB_PASS';
EOF
fi

exec "$@"

