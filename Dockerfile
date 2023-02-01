# FROM quay.io/devfile/universal-developer-image:ubi8-latest
# FROM redhat/ubi8
FROM quay.io/devfile/base-developer-image

# Java
ENV JAVA_HOME="/home/user/.sdkman/candidates/java/current" \
    JAVA_HOME_8=/home/user/.sdkman/candidates/java/8.0.362-tem \
    JAVA_HOME_11=/home/user/.sdkman/candidates/java/11.0.15-tem \
    PATH="/home/user/.sdkman/candidates/java/current/bin:$PATH"

# maven
ENV MAVEN_HOME="/home/user/.sdkman/candidates/maven/current" \
    PATH="/home/user/.sdkman/candidates/maven/current/bin:$PATH"

# install packages
RUN curl -fsSL "https://get.sdkman.io" | bash ; \
    source "/home/user/.sdkman/bin/sdkman-init.sh" ; \
    sed -i "s/sdkman_auto_answer=false/sdkman_auto_answer=true/g" /home/user/.sdkman/etc/config ; \
    sdk install java 8.0.362-tem ; \
    sdk install java 11.0.15-tem ; \
    sdk default 8.0.362-tem \
    sdk install maven 3.3.3 ; \
    sdk flush archives ; \
    sdk flush temp ;

# exec with root user
USER 0

# Set permissions on /etc/passwd and /home to allow arbitrary users to write
RUN mkdir -p /home/user && chgrp -R 0 /home && chmod -R g=u /etc/passwd /etc/group /home

# cleanup dnf cache
RUN dnf -y clean all --enablerepo='*'

# exec with normal user
USER 10001

# # apache maven
# ARG MAVEN_VERSION=3.3.3
# ENV M2_HOME=/usr/lib/apache-maven-${MAVEN_VERSION}
# ENV MAVEN_OPTS="-Xmx2048m -XX:ReservedCodeCacheSize=128m -Dsun.lang.ClassLoader.allowArraySyntax=true"

# # openjdk
# ENV JAVA_HOME_8=/usr/lib/jvm/java-8-openjdk
# ENV JAVA_HOME_11=/usr/lib/jvm/java-11-openjdk
# ENV JAVA_HOME=${JAVA_HOME_8}

# # path
# ENV PATH=$PATH:${JAVA_HOME}/bin:${M2_HOME}/bin:${SONAR_CLI_HOME}/bin

# # install required packages
# RUN apk add --no-cache \
#       bash busybox-extras \
#       ca-certificates curl \
#       git \
#       openjdk8 openjdk11 openssh openssl shadow \
#       unzip ; \
#     \
# # install apache maven
#     wget -c https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz -O - | tar -xz -C /usr/lib/ ; \
#     \
# # remove unnecessary packages and files
#     rm -rf \
#       ${JAVA_HOME_8}/demo \
#       ${JAVA_HOME_8}/jmods \
#       ${JAVA_HOME_8}/man \
#       ${JAVA_HOME_11}/demo \
#       ${JAVA_HOME_11}/jmods \
#       ${JAVA_HOME_11}/man ;

# # install certificate
# COPY certs /usr/local/share/ca-certificates
# RUN update-ca-certificates ;

# # create service account
# RUN adduser \
#       -S user \
#       -h /home/user \
#       -s /bin/bash \
#       -G root \
#       -u 10001 ; \
#       \
#     echo "%root ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers ;

# # config files
# # COPY config/settings.xml ${M2_HOME}/conf/settings.xml
# COPY entrypoint.sh /usr/bin
# RUN chmod +x /usr/bin/entrypoint.sh

# # ports
# EXPOSE 22 5005 8080

# # # pre configuration
# # ENTRYPOINT entrypoint.sh

# # default directory
# WORKDIR /projects

# # run container
# # USER 10001
# # ENV HOME=/home/user
# # CMD tail -f /dev/null
