FROM ubuntu:18.04
MAINTAINER Simon Green <simonpetergreen@singaren.net.sg>

ENV RADSECPROXY_VERSION 1.8.1
ENV DEBIAN_FRONTEND noninteractive
ENV TZ UTC 
WORKDIR /opt

COPY run.sh patch/radsecproxy-log-opname-cui.diff /root/
RUN apt-get update && apt-get upgrade -y && \
    apt-get install build-essential libssl-dev make nettle-dev curl tzdata -y && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sLo radsecproxy-${RADSECPROXY_VERSION}.tar.gz  \
        https://github.com/radsecproxy/radsecproxy/releases/download/${RADSECPROXY_VERSION}/radsecproxy-${RADSECPROXY_VERSION}.tar.gz && \
    tar xvf radsecproxy-${RADSECPROXY_VERSION}.tar.gz && \
    rm radsecproxy-${RADSECPROXY_VERSION}.tar.gz &&\
    cd radsecproxy-${RADSECPROXY_VERSION} && \
    patch -p1 < /root/radsecproxy-log-opname-cui.diff && \
    ./configure --prefix=/ && \
    make && \
    make check && \
    make install && \
    mkdir /var/log/radsecproxy/ && \
    touch /var/log/radsecproxy/radsecproxy.log

EXPOSE 1812/udp 1813/udp

CMD ["/root/run.sh"]
