#!/bin/sh

docker run -d --name test_mariadb -e MARIADB_ROOT_PASS=password bbrfkr0129/openstack_mariadb
sleep 20 

Bin/edge spec openstack_keystone

docker rm -f test_mariadb
