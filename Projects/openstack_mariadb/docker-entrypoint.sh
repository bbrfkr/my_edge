#!/bin/sh

SKIP_SECURE_INSTALLATION=0

if [ "$MARIADB_ROOT_PASS" = "" ] ; then
  echo "ERROR: MARIADB_ROOT_PASS is not set!!"
  exit 1
fi

mysqld_safe &
DO_CMD="mysql -uroot -e 'show databases;' 2>&1 \
        | grep \"Can't connect to local MySQL server through socket\""
/bin/sh -c "$DO_CMD"
while [ $? -eq 0 ]
do
  sleep 1
  /bin/sh -c "$DO_CMD"
done

mysql -uroot -e "show databases;" 2>&1 > /dev/null
if [ $? -ne 0 ] ; then
  echo "mariadb root password is already set"
  SKIP_SECURE_INSTALLATION=1
fi

if [ $SKIP_SECURE_INSTALLATION -ne 1 ] ; then
  /tmp/mysql_secure_installation.sh $MARIADB_ROOT_PASS
fi

mysql -uroot -p$MARIADB_ROOT_PASS \
      -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' \
          IDENTIFIED BY '$MARIADB_ROOT_PASS' WITH GRANT OPTION;"

mysqladmin -uroot -p$MARIADB_ROOT_PASS shutdown

exec "$@"
