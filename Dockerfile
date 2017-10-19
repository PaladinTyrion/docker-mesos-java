FROM java:8-jdk

ARG MESOS_VERSION=0.28.1-2.0.20.ubuntu1404

RUN apt-get update && \
  apt-get install --no-install-recommends -y apt-transport-https ca-certificates curl && \
  apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D && \
  echo deb https://apt.dockerproject.org/repo debian main > /etc/apt/sources.list.d/docker.list && \
  apt-get update && \
  apt-get -y install docker-engine

RUN echo "deb http://repos.mesosphere.com/ubuntu ubuntu main" > /etc/apt/sources.list.d/mesosphere.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
  apt-get -y update && \
  apt-get -y install curl mesos=${MESOS_VERSION} && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

ENV MESOS_WORK_DIR /tmp/mesos
ENV MESOS_LOG_DIR /var/log/mesos
ENV MESOS_CONTAINERIZERS docker,mesos
ENV MESOS_NATIVE_JAVA_LIBRARY /usr/local/lib/libmesos.so

# https://mesosphere.github.io/marathon/docs/native-docker.html
ENV MESOS_EXECUTOR_REGISTRATION_TIMEOUT 5mins

# https://issues.apache.org/jira/browse/MESOS-4675
ENV MESOS_SYSTEMD_ENABLE_SUPPORT false

VOLUME /tmp/mesos

VOLUME /var/log/mesos
