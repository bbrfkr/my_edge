FROM docker.io/centos:7.3.1611

ENV http_proxy http://192.168.128.28:8080
ENV https_proxy http://192.168.128.28:8080
ENV HTTP_PROXY http://192.168.128.28:8080
ENV HTTPS_PROXY http://192.168.128.28:8080

RUN yum -y install centos-release-openstack-ocata
RUN yum -y upgrade
RUN yum -y install python-openstackclient openstack-selinux
RUN yum -y install mariadb

ARG SET_TZ
ENV TZ $SET_TZ

