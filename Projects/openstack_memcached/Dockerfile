FROM bbrfkr0129/openstack_common:latest

RUN yum -y install memcached python-memcached
RUN sed -i 's/OPTIONS="-l .*"/OPTIONS="-l 0.0.0.0"/g' /etc/sysconfig/memcached
EXPOSE 11211 11211/udp
CMD ["memcached", "-u", "memcached"]
