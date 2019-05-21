From jenkins/jenkins
USER root

RUN curl -O https://bootstrap.pypa.io/get-pip.py
RUN apt-get update -y
#RUN python get-pip.py --user
RUN apt install python-pip --reinstall -y
RUN pip install awscli --upgrade --user
RUN apt-get update

RUN apt-get update
ENV DOCKER_BUCKET get.docker.com
ENV DOCKER_SHA256 83be159cf0657df9e1a1a4a127d181725a982714a983b2bdcc0621244df93687
ENV DOCKER_HOME /tmp/docker_tar
ENV DOCKER_HOST unix:///var/run/docker.sock
# GID currently in use by AWS EC2 Container Service
ENV DOCKER_GID 497

RUN apt-get install curl -y
RUN curl -fSL "https://download.docker.com/linux/static/stable/x86_64/docker-18.06.1-ce.tgz" -o ${DOCKER_HOME} \
    && echo "${DOCKER_SHA256} ${DOCKER_HOME}" | sha256sum -c - \
    && chmod +x ${DOCKER_HOME}
#RUN curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
RUN curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
RUN chmod +x /usr/local/bin/docker-compose
RUN tar -xvf /tmp/docker_tar -C /tmp
RUN cp /tmp/docker/docker /usr/bin/docker
RUN groupadd -g ${DOCKER_GID} docker
RUN usermod -G docker jenkins
RUN \
  # install utilities
  apt-get update && apt-get install -y \
     wget \
     curl \
     vim \
     git \
     zip \
     bzip2 \
     fontconfig \
     python \
     python-pip \
     jq \
     sudo
RUN echo "jenkins ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
   chmod 0440 /etc/sudoers.d/user

