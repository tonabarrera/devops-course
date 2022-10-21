FROM jenkins/jenkins:lts-jdk11
USER root

# Install the latest Docker CE binaries and add user jenkins to the docker group
RUN apt-get update && \
    apt-get -y --no-install-recommends install apt-transport-https \
      ca-certificates \
      curl \
      wget \
      tar \
      gnupg2 \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y --no-install-recommends install docker-ce && \
   apt-get clean && \
   usermod -aG docker jenkins

ARG LIQUIBASE_VERSION=3.10.1

RUN mkdir /opt/liquibase && \
  wget -O liquibase-${LIQUIBASE_VERSION}.tar.gz "https://github.com/liquibase/liquibase/releases/download/v${LIQUIBASE_VERSION}/liquibase-${LIQUIBASE_VERSION}.tar.gz"  && \
  tar -xzf liquibase-${LIQUIBASE_VERSION}.tar.gz -C /opt/liquibase && \
  rm liquibase-${LIQUIBASE_VERSION}.tar.gz