FROM centos:7.3.1611

WORKDIR /root

# install ansible
RUN yum -y install gcc python-devel openssl-devel libffi-devel
RUN curl -o /tmp/get-pip.py https://bootstrap.pypa.io/get-pip.py
RUN python /tmp/get-pip.py
ARG ANSIBLE_VER
RUN if [ "$ANSIBLE_VER" = "" ] ; then \
      pip install ansible ; \
    else \
      pip install ansible==$ANSIBLE_VER ; \
    fi

# install ruby
RUN yum -y install git bzip2 make readline-devel
RUN git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
RUN echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
RUN git clone git://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN cd ~/.rbenv/plugins/ruby-build && ./install.sh && cd -
ARG RUBY_VER 
RUN source ~/.bash_profile && rbenv install $RUBY_VER
RUN source ~/.bash_profile && rbenv rehash
RUN source ~/.bash_profile && rbenv global $RUBY_VER

# install itamae serverspec infrataster
ARG ITAMAE_VER 
RUN if [ "$ITAMAE_VER" = "" ] ; then \
      source ~/.bash_profile && gem install itamae ; \
    else \
      source ~/.bash_profile && gem install itamae -v $ITAMAE_VER ; \
    fi
ARG SERVERSPEC_VER
RUN if [ "$SERVERSPEC_VER" = "" ] ; then \
      source ~/.bash_profile && gem install serverspec ; \
    else \
      source ~/.bash_profile && gem install serverspec -v $SERVERSPEC_VER ; \
    fi
ARG INFRATASTER_VER
RUN if [ "$INFRATASTER_VER" = "" ] ; then \
      source ~/.bash_profile && gem install infrataster ; \
    else \
      source ~/.bash_profile && gem install infrataster -v $INFRATASTER_VER ; \
    fi
RUN source ~/.bash_profile && gem uninstall thor --all --force
RUN source ~/.bash_profile && gem install thor -v 0.19.1

# install docker-api
ARG DOCKER_API_VER
RUN if [ "$DOCKER_API_VER" = "" ] ; then \
      source ~/.bash_profile && gem install docker-api ; \
    else \
      source ~/.bash_profile && gem install docker-api -v $DOCKER_API_VER ; \
    fi

# install utility gems
RUN source ~/.bash_profile && gem install inifile activesupport

# install docker
RUN yum -y install docker
RUN mkdir /root/.docker

# install docker-compose
ARG DOCKER_COMPOSE_VER
RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose

# enable ssh
RUN yum -y install openssh-server
RUN ssh-keygen -A 
ARG ROOT_PASS
RUN echo $ROOT_PASS | passwd --stdin root

CMD ["/usr/sbin/sshd", "-D"]

