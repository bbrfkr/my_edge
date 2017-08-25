FROM docker.io/centos:7.3.1611

VOLUME ["/var/lib/mysql"]

RUN yum -y install mariadb-server expect
COPY mysql_secure_installation.sh /tmp/mysql_secure_installation.sh

EXPOSE 3306

COPY check_variables /tmp/check_variables
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mysqld_safe"]
