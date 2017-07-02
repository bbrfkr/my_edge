FROM bbrfkr0129/openstack_common:latest

RUN yum -y install rabbitmq-server
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["rabbitmq-server"]
