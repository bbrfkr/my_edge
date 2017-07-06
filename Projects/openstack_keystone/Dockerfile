FROM bbrfkr0129/openstack_common:latest

RUN yum -y install openstack-keystone httpd mod_wsgi
COPY keystone.conf /etc/keystone/keystone.conf
RUN chgrp keystone /etc/keystone/keystone.conf
RUN ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 35357 5000

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["apachectl", "-DFOREGROUND"]

