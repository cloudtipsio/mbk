# base image - https://github.com/devfile/developer-images
FROM quay.io/devfile/base-developer-image

# exec with root user
USER 0

# install internal certificates
COPY certs/*.crt /etc/ssl/certs/
RUN update-ca-trust ;

# exec with normal user
USER 10001

# install packages
RUN curl -fsSL "https://get.sdkman.io" | bash ; \
    source "/home/user/.sdkman/bin/sdkman-init.sh" ; \
    sed -i "s/sdkman_auto_answer=false/sdkman_auto_answer=true/g" /home/user/.sdkman/etc/config ; \
    sdk install java 11.0.15-tem ; \
    sdk install java 8.0.362-tem ; \
    sdk install maven 3.3.3 ; \
    sdk flush archives ; \
    sdk flush temp ;

# Java
ENV JAVA_HOME="/home/user/.sdkman/candidates/java/current" \
    JAVA_HOME_8=/home/user/.sdkman/candidates/java/8.0.362-tem \
    JAVA_HOME_11=/home/user/.sdkman/candidates/java/11.0.15-tem \
    PATH="/home/user/.sdkman/candidates/java/current/bin:$PATH"

# maven
ENV MAVEN_HOME="/home/user/.sdkman/candidates/maven/current" \
    PATH="/home/user/.sdkman/candidates/maven/current/bin:$PATH"
COPY files/settings.xml /home/user/.sdkman/candidates/maven/current/conf/settings.xml

# default directory
WORKDIR /project
