#
# Scala and sbt Dockerfile
#
# https://github.com/albal/scala-sbt
#

# Pull base image
FROM openjdk:8

ENV SCALA_VERSION 2.12.13
ENV SBT_VERSION 1.4.7

# Scala expects this file
RUN mkdir -p /usr/lib/jvm/java-8-openjdk-amd64 && touch /usr/lib/jvm/java-8-openjdk-amd64/release

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  cd /root && \
  curl -L -o sbt-$SBT_VERSION.deb http://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install sbt && \
  sbt sbtVersion
  
# Install AWS Cli
RUN apt-get install jq gettext python3-pip -y && pip3 install awscli

# Define working directory
WORKDIR /root
