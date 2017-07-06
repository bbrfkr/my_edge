FROM bbrfkr0129/openstack_glance_common:latest

COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh
COPY glance-api.conf /etc/glance/glance-api.conf
RUN chown root:glance /etc/glance/glance-api.conf
ENTRYPOINT ["docker-entrypoint.sh"]
EXPOSE 9292
CMD ["glance-api"]

