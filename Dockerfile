FROM openjdk:8-jdk-alpine

ARG ARTHAS_VERSION="3.6.5"
ARG MIRROR=false

ENV MAVEN_HOST=https://repo1.maven.org/maven2 \
    ALPINE_HOST=dl-cdn.alpinelinux.org \
    MIRROR_MAVEN_HOST=https://maven.aliyun.com/repository/public \
    MIRROR_ALPINE_HOST=mirrors.aliyun.com

# if use mirror change to aliyun mirror site
RUN if $MIRROR; then MAVEN_HOST=${MIRROR_MAVEN_HOST} ;ALPINE_HOST=${MIRROR_ALPINE_HOST} ; sed -i "s/dl-cdn.alpinelinux.org/${ALPINE_HOST}/g" /etc/apk/repositories ; fi && \
    # https://github.com/docker-library/openjdk/issues/76
    apk add --no-cache tini && \
    # download & install arthas
    wget -qO /tmp/arthas.zip "${MAVEN_HOST}/com/taobao/arthas/arthas-packaging/${ARTHAS_VERSION}/arthas-packaging-${ARTHAS_VERSION}-bin.zip" && \
    mkdir -p /opt/arthas && \
    unzip /tmp/arthas.zip -d /opt/arthas && \
    rm /tmp/arthas.zip && \
    wget -qO /opt/arthas/arthas-tunnel-server.jar "${MAVEN_HOST}/com/taobao/arthas/arthas-tunnel-server/${ARTHAS_VERSION}/arthas-tunnel-server-${ARTHAS_VERSION}-fatjar.jar"

# Tini is now available at /sbin/tini
ENTRYPOINT ["/sbin/tini", "--"]