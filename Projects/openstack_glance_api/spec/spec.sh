#!/bin/sh

docker run -d --name test_mariadb -e MARIADB_ROOT_PASS=password bbrfkr0129/openstack_mariadb
docker run -d --name test_memcached bbrfkr0129/openstack_memcached
docker run -d --name test_keystone \
  -e MARIADB_ROOT_PASS=password \
  -e KEYSTONE_DB_PASS=password \
  -e ADMIN_PASS=password \
  -e REGION_NAME=RegionOne \
  -e OS_USERNAME=admin \
  -e OS_PASSWORD=password \
  -e OS_PROJECT_NAME=admin \
  -e OS_USER_DOMAIN_NAME=default \
  -e OS_PROJECT_DOMAIN_NAME=default \
  -e OS_AUTH_URL=http://localhost:35357/v3 \
  -e OS_IDENTITY_API_VERSION=3 \
  --link test_mariadb:mariadb \
  bbrfkr0129/openstack_keystone

Bin/edge spec openstack_glance_api

docker rm -f test_mariadb
docker rm -f test_keystone
docker rm -f test_memcached
