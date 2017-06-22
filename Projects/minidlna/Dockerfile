# Dockerfile for dlna server
FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:djart/minidlna -y
RUN apt-get update && apt-get install -y minidlna
ARG MEDIA_DIR
RUN sed -i "s@media_dir=.*@media_dir=${MEDIA_DIR}@g" /etc/minidlna.conf
CMD service minidlna start && /bin/bash -l

