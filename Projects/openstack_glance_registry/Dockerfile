FROM bbrfkr0129/openstack_glance_common:latest

COPY glance-registry.conf /etc/glance/glance-registry.conf
RUN chown root:glance /etc/glance/glance-registry.conf
COPY docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 9191
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["glance-registry"]

