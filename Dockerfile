FROM openjdk:8-jre-alpine
MAINTAINER Justin Plock <justin@plock.net>

ARG MIRROR=http://apache.mirrors.pair.com
ARG VERSION=3.4.8

LABEL name="zookeeper" version=$VERSION

RUN apk add --no-cache wget bash \
    && mkdir /opt \
    && wget -q -O - $MIRROR/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz | tar -xzf - -C /opt \
    && mv /opt/zookeeper-$VERSION /opt/zookeeper \
    && cp /opt/zookeeper/conf/zoo_sample.cfg /opt/zookeeper/conf/zoo.cfg \
    && mkdir -p /tmp/zookeeper

EXPOSE 2181 2888 3888

WORKDIR /opt/zookeeper

ENV tickTime=2000
ENV dataDir=/tmp/zookeeper
ENV clientPort=2181
ENV initLimit=10
ENV syncLimit=2

VOLUME ["/opt/zookeeper/conf", "/tmp/zookeeper"]

ENTRYPOINT ["/opt/zookeeper/bin/zkServer.sh"]
CMD ["start-foreground"]
