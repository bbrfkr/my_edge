FROM jenkins:2.46.3

USER root
RUN apt-get update

# install jq
ARG JQ_VER
RUN curl -o /usr/local/bin/jq -L https://github.com/stedolan/jq/releases/download/jq-${JQ_VER}/jq-linux64 && \
    chmod +x /usr/local/bin/jq

# install docker
RUN apt-get -y install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/debian \
    $(lsb_release -cs) \
    stable"
RUN apt-get update
RUN apt-get -y install docker-ce

# install docker -compose
ARG DOCKER_COMPOSE_VER
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# install sshpass
RUN apt-get -y install sshpass

USER jenkins
ARG SET_TZ
ENV TZ $SET_TZ

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/jenkins.sh"]


