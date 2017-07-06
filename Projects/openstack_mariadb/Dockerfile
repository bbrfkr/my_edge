FROM bbrfkr0129/openstack_common:latest

VOLUME /var/lib/mysql

RUN yum -y install mariadb-server python2-PyMySQL
COPY openstack.cnf /etc/my.cnf.d/openstack.cnf
RUN yum -y install expect
COPY mysql_secure_installation.sh /tmp/mysql_secure_installation.sh
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe"]

