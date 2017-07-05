#!/bin/sh

mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR -e "show databases;" | grep "keystone"
if [ $? -ne 0 ] ; then
  mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR mysql <<EOF
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$KEYSTONE_DB_PASS';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$KEYSTONE_DB_PASS';
EOF
fi

sed -i "s/KEYSTONE_DB_PASS/$KEYSTONE_DB_PASS/g" /etc/keystone/keystone.conf
sed -i "s/MARIADB_HOSTNAME/$MARIADB_PORT_3306_TCP_ADDR/g" /etc/keystone/keystone.conf

mysql -uroot -p$MARIADB_ROOT_PASS -h$MARIADB_PORT_3306_TCP_ADDR keystone -e "show tables;" \
  | grep "Tables_in_keystone"
if [ $? -ne 0 ] ; then
  su -s /bin/sh -c "keystone-manage db_sync" keystone
fi

if [ ! -d /etc/keystone/fernet-keys ] ; then
  keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
fi
if [ ! -d /etc/keystone/credential-keys ] ; then
  keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
fi

MY_IP=`ip a | grep eth0 | grep inet | awk '{ print $2 }' | sed 's/\/.*//g'` 

sed -i "s/\#\?ServerName .*/ServerName `uname -n`/g" /etc/httpd/conf/httpd.conf

export OS_USERNAME=admin
export OS_PASSWORD=$ADMIN_PASS
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_DOMAIN_NAME=default
export OS_AUTH_URL=http://$MY_IP:35357/v3
export OS_IDENTITY_API_VERSION=3
unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY

apachectl

openstack project list | grep admin
if [ $? -ne 0 ] ; then
  keystone-manage bootstrap \
    --bootstrap-password $ADMIN_PASS \
    --bootstrap-username admin \
    --bootstrap-project-name admin \
    --bootstrap-role-name admin \
    --bootstrap-service-name keystone \
    --bootstrap-region-id $REGION_NAME \
    --bootstrap-admin-url http://$MY_IP:35357 \
    --bootstrap-public-url http://$MY_IP:5000 \
    --bootstrap-internal-url http://$MY_IP:5000
fi

openstack project list | grep service
if [ $? -ne 0 ] ; then
  openstack project create --domain default --description "Service Project" service
fi

openstack role list | grep user
if [ $? -ne 0 ] ; then
  openstack role create user
fi

apachectl -k graceful-stop

grep " admin_token_auth " /etc/keystone/keystone-paste.ini
if [ $? -eq 0 ] ; then
  sed -i 's/ admin_token_auth / /g'  /etc/keystone/keystone-paste.ini
fi

exec "$@"

