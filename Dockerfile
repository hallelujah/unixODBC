FROM ubuntu:xenial

USER root

RUN apt-get update -y \
  && apt-get install -y software-properties-common \
  && add-apt-repository -y ppa:brightbox/ruby-ng \
  && apt-get install -y python-software-properties \
  && apt-get update -y \
  && apt-get install -y ruby2.3 ruby2.3-dev build-essential curl \
  && gem install --no-ri --no-rdoc fpm \
  && mkdir -p /opt/unixodbc \
  && chown 1000:0 /opt/unixodbc

USER 1000

WORKDIR /opt/unixodbc

ARG NAME=unixODBC
ARG VERSION=2.3.6

RUN curl http://www.unixodbc.org/${NAME}-${VERSION}.tar.gz | tar -xzC /opt/unixodbc \
  && cd $NAME-$VERSION \
  && ./configure --prefix=/usr \
  && make \
  && mkdir /tmp/installdir \
  && make install DESTDIR=/tmp/installdir \
  && fpm -s dir -t deb -n $NAME -v $VERSION \
  -C /tmp/installdir \
  -p ${NAME}_VERSION_ARCH.deb \
  usr
