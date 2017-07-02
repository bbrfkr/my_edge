FROM docker.io/centos:7.3.1611

RUN yum -y install centos-release-openstack-ocata
RUN yum -y upgrade
RUN yum -y install python-openstackclient openstack-selinux

ARG SET_TZ
ENV TZ $SET_TZ

