# base image - https://github.com/devfile/developer-images
FROM quay.io/devfile/base-developer-image

# exec with root user
USER 0

# install internal certificates
COPY files/*.crt /etc/ssl/certs/
RUN update-ca-trust ;

# exec with normal user
USER 10001

# Java
ENV JAVA_VERSION=8.0.362 \
    JAVA_HOME=/home/user/.sdkman/candidates/java/current

# maven
ENV MAVEN_VERSION=3.3.3 \
    MAVEN_HOME=/home/user/.sdkman/candidates/maven/current

# path
ENV PATH=${JAVA_HOME}/bin:${MAVEN_HOME}/bin:$PATH

# install packages
RUN curl -fsSL "https://get.sdkman.io" | bash ; \
    source "/home/user/.sdkman/bin/sdkman-init.sh" ; \
    sed -i "s/sdkman_auto_answer=false/sdkman_auto_answer=true/g" /home/user/.sdkman/etc/config ; \
    sdk update ; \
    sdk install java ${JAVA_VERSION}-tem ; \
    sdk install maven ${MAVEN_VERSION} ; \
    sdk flush archives ; \
    sdk flush temp ;

# maven default configuration for maven
COPY files/settings.xml /home/user/.sdkman/candidates/maven/current/conf/settings.xml

# default directory
WORKDIR /project
