#!/bin/sh

until mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR -e "show databases;" > /dev/null
do
  sleep 1
done
echo ""
echo "MariaDB is started"

mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR -e "show databases;" | grep "glance" > /dev/null
if [ $? -ne 0 ] ; then
  mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR mysql <<EOF
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$GLANCE_DB_PASS';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$GLANCE_DB_PASS';
EOF
fi

export OS_AUTH_URL=http://$KEYSTONE_PORT_35357_TCP_ADDR:35357/v3
unset http_proxy HTTP_PROXY https_proxy HTTPS_PROXY

until openstack project list > /dev/null
do
  sleep 1
done
echo ""
echo "Keystone is started"

openstack user list | grep "glance" > /dev/null
if [ $? -ne 0 ] ; then
  openstack user create --domain default --password $GLANCE_USER_PASS glance
fi

openstack role list --project service --user glance | grep "admin" > /dev/null
if [ $? -ne 0 ] ; then
  openstack role add --project service --user glance admin
fi

openstack service list | grep "glance" > /dev/null
if [ $? -ne 0 ] ; then
  openstack service create --name glance --description "OpenStack Image" image  
fi

ENDPOINT_LIST=`openstack endpoint list | grep "glance"`
MY_IP=`ip a | grep eth0 | grep inet | awk '{ print $2 }' | sed 's/\/.*//g'`

echo $ENDPOINT_LIST | grep "public" > /dev/null
if [ $? -ne 0 ] ; then
  openstack endpoint create --region RegionOne image public http://$MY_IP:9292
fi
echo $ENDPOINT_LIST | grep "internal" > /dev/null
if [ $? -ne 0 ] ; then
  openstack endpoint create --region RegionOne image internal http://$MY_IP:9292
fi
echo $ENDPOINT_LIST | grep "admin" > /dev/null
if [ $? -ne 0 ] ; then
  openstack endpoint create --region RegionOne image admin http://$MY_IP:9292
fi

sed -i "s/GLANCE_DB_PASS/$GLANCE_DB_PASS/g" /etc/glance/glance-api.conf
sed -i "s/MARIADB_HOSTNAME/$MARIADB_PORT_3306_TCP_ADDR/g" /etc/glance/glance-api.conf
sed -i "s/KEYSTONE_HOSTNAME/$KEYSTONE_PORT_35357_TCP_ADDR/g" /etc/glance/glance-api.conf
sed -i "s/MEMCACHED_HOSTNAME/$MEMCACHED_PORT_11211_TCP_ADDR/g" /etc/glance/glance-api.conf
sed -i "s/GLANCE_USER_PASS/$GLANCE_USER_PASS/g" /etc/glance/glance-api.conf

mysql -uroot -ppassword -h$MARIADB_PORT_3306_TCP_ADDR glance -e "show tables;" | grep "Tables_in_glance"
if [ $? -ne 0 ] ; then
  su -s /bin/sh -c "glance-manage db_sync" glance
fi

exec "$@"

