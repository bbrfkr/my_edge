#!/bin/sh

DO_CMD1="rabbitmqctl list_vhosts | grep \"^/$\""
DO_CMD2="ps -ef | grep \"^rabbitmq\" | wc -l"

rabbitmq-server &

/bin/sh -c "$DO_CMD1"
while [ $? -ne 0 ]
do
  sleep 1
  /bin/sh -c "$DO_CMD1"
done

rabbitmqctl list_users | grep openstack
if [ $? -ne 0 ] ; then
  rabbitmqctl add_user openstack $RABBITMQ_USER_PASS
fi

rabbitmqctl list_permissions | grep openstack
if [ $? -ne 0 ] ; then
  rabbitmqctl set_permissions openstack ".*" ".*" ".*"
fi

rabbitmqctl stop

PS_COUNT=`/bin/sh -c "$DO_CMD2"`
while [ $PS_COUNT -ne 1 ]
do
  sleep 1
  PS_COUNT=`/bin/sh -c "$DO_CMD2"`
done

exec "$@"

