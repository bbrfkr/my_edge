#!/bin/sh

sed -i "s/GLANCE_DB_PASS/$GLANCE_DB_PASS/g" /etc/glance/glance-registry.conf
sed -i "s/MARIADB_HOSTNAME/$MARIADB_PORT_3306_TCP_ADDR/g" /etc/glance/glance-registry.conf
sed -i "s/KEYSTONE_HOSTNAME/$KEYSTONE_PORT_35357_TCP_ADDR/g" /etc/glance/glance-registry.conf
sed -i "s/MEMCACHED_HOSTNAME/$MEMCACHED_PORT_11211_TCP_ADDR/g" /etc/glance/glance-registry.conf
sed -i "s/GLANCE_USER_PASS/$GLANCE_USER_PASS/g" /etc/glance/glance-registry.conf

exec "$@"

