FROM bbrfkr0129/openstack_common:latest

RUN yum -y install mariadb mariadb-server python2-PyMySQL
COPY openstack.cnf /etc/my.cnf.d/openstack.cnf
RUN mysql_install_db --datadir=/var/lib/mysql --user=mysql
RUN yum -y install expect
COPY mysql_secure_installation.sh /tmp/mysql_secure_installation.sh
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe"]

