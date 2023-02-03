FROM alpine:3.15

# apache maven
ARG MAVEN_VERSION=3.3.3
ENV M2_HOME=/usr/lib/apache-maven-${MAVEN_VERSION}
ENV MAVEN_OPTS="-Xmx2048m -XX:ReservedCodeCacheSize=128m -Dsun.lang.ClassLoader.allowArraySyntax=true"

# openjdk
ENV JAVA_HOME_8=/usr/lib/jvm/java-8-openjdk
ENV JAVA_HOME_11=/usr/lib/jvm/java-11-openjdk
ENV JAVA_HOME=${JAVA_HOME_8}

# path
ENV PATH=$PATH:${JAVA_HOME}/bin:${M2_HOME}/bin:${SONAR_CLI_HOME}/bin

# install required packages
RUN apk add --no-cache \
      bash busybox-extras \
      ca-certificates curl \
      git \
      openjdk8 openjdk11 openssh openssl shadow \
      unzip ; \
    \
# install apache maven
    wget -c https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O - | tar -xz -C /usr/lib/ ; \
    \
# remove unnecessary packages and files
    rm -rf \
      ${JAVA_HOME_8}/demo \
      ${JAVA_HOME_8}/jmods \
      ${JAVA_HOME_8}/man \
      ${JAVA_HOME_11}/demo \
      ${JAVA_HOME_11}/jmods \
      ${JAVA_HOME_11}/man ;

# install certificate
COPY certs /usr/local/share/ca-certificates
RUN update-ca-certificates ;

# create service account
RUN adduser \
      -S user \
      -h /home/user \
      -s /bin/bash \
      -G root \
      -u 10001 ; \
      \
    echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers ;

# config files
# COPY config/settings.xml ${M2_HOME}/conf/settings.xml
COPY entrypoint.sh /usr/bin
RUN chmod +x /usr/bin/entrypoint.sh

# ports
EXPOSE 22 5005 8080

# # pre configuration
# ENTRYPOINT entrypoint.sh

# default directory
WORKDIR /projects

# run container
# USER 10001
# ENV HOME=/home/user
# CMD tail -f /dev/null
