#!/bin/sh
source /tmp/check_variables

SKIP_SECURE_INSTALLATION=0

if [ -z "`ls -1 /var/lib/mysql`" ] ; then
  echo "##########"
  echo "initialize datadir..."
  echo "##########"

  mysql_install_db --datadir=/var/lib/mysql --user=mysql
else
  echo "##########"
  echo "datadir is already initialized"
  echo "##########"
fi

echo "##########"
echo "start mysqld temporarily"
echo "wait mysqld is started"
echo "##########"

mysqld_safe &

DO_CMD="mysql -uroot -e 'show databases;' 2>&1 | \
          grep \"Can't connect to local MySQL server through socket\" > \
          /dev/null"

/bin/sh -c "$DO_CMD"
while [ $? -eq 0 ]
do
  sleep 1
  /bin/sh -c "$DO_CMD"
done

echo "##########"
echo "mysqld has been started"
echo "##########"

mysql -uroot -e "show databases;" > /dev/null 2>&1
if [ $? -ne 0 ] ; then
  echo "##########"
  echo "mariadb root password is already set"
  echo "mysql_secure_installation is skipped..."
  echo "##########"

  SKIP_SECURE_INSTALLATION=1
else
  echo "##########"
  echo "mariadb root password is not set!"
  echo "try mysql_secure_installation"
  echo "##########"
fi

if [ $SKIP_SECURE_INSTALLATION -eq 0 ] ; then
  /tmp/mysql_secure_installation.sh $MARIADB_ROOT_PASS

  echo "##########"
  echo "mysql_secure_installation has been completed"
  echo "##########"
fi

echo "##########"
echo "permit root access from outside of container"
echo "##########"

mysql -uroot -p$MARIADB_ROOT_PASS \
      -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' \
          IDENTIFIED BY '$MARIADB_ROOT_PASS' WITH GRANT OPTION;"

echo "##########"
echo "restart mysqld"
echo "##########"

mysqladmin -uroot -p$MARIADB_ROOT_PASS shutdown
exec "$@"

