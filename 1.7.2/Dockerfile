FROM ubuntu:18.04
MAINTAINER Simon Green <simonpetergreen@singaren.net.sg>

ENV RADSECPROXY_VERSION 1.7.2 
ENV EXAMPLE_RADSECPROXY_CONF_SHA256 2cd1461dd7eda085d1f0b68017dc57f15c61fd2536a789028e49d2383cdf734a
ENV DEBIAN_FRONTEND noninteractive
ENV TZ UTC

WORKDIR /opt

COPY run.sh /root/
RUN apt-get update && apt-get upgrade -y && \
    apt-get install build-essential libssl-dev make nettle-dev curl tzdata -y && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sLo radsecproxy-${RADSECPROXY_VERSION}.tar.gz  \
        https://github.com/radsecproxy/radsecproxy/releases/download/${RADSECPROXY_VERSION}/radsecproxy-${RADSECPROXY_VERSION}.tar.gz && \
    tar xvf radsecproxy-${RADSECPROXY_VERSION}.tar.gz && \
    rm radsecproxy-${RADSECPROXY_VERSION}.tar.gz &&\
    cd radsecproxy-${RADSECPROXY_VERSION} && \
    ./configure --prefix=/ && \
    make && \
    make check && \
    make install && \
    mkdir /var/log/radsecproxy/ && \
    touch /var/log/radsecproxy/radsecproxy.log && \
    curl -fsL -o radsecproxy.conf \
        "https://raw.githubusercontent.com/spgreen/eduroam-radsecproxy-docker/master/example-configuration/radsecproxy.conf" && \
    echo "$EXAMPLE_RADSECPROXY_CONF_SHA256 *radsecproxy.conf" | sha256sum -c - && \
    mv radsecproxy.conf /etc/radsecproxy.conf

EXPOSE 1812/udp 1813/udp

CMD ["/root/run.sh"]
