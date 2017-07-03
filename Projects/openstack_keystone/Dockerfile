FROM bbrfkr0129/openstack_common:latest

RUN yum -y install openstack-keystone httpd mod_wsgi
RUN yum -y install mariadb
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]

