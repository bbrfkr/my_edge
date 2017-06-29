FROM bbrfkr/openstack_common:latest

RUN yum -y install mariadb mariadb-server python2-PyMySQL
COPY openstack.cnf /etc/my.cnf.d/openstack.cnf
RUN mysql_install_db --datadir=/var/lib/mysql --user=mysql
CMD ["/usr/bin/mysqld_safe"]

