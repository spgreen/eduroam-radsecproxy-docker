FROM ubuntu:18.04
MAINTAINER Simon Green <simonpetergreen@singaren.net.sg>

ENV EXAMPLE_RADSECPROXY_CONF_SHA256 2cd1461dd7eda085d1f0b68017dc57f15c61fd2536a789028e49d2383cdf734a
ENV T_FTICKS_PATCH_SHA256 71d38380012479c0905665bbaece8d190521ac10987538ac276a709614d66e00
ENV DEBIAN_FRONTEND noninteractive
ENV TZ UTC 
WORKDIR /opt

COPY run.sh patch/radsecproxy-log-opname-cui.diff /root/
RUN apt-get update && apt-get upgrade -y && \
    apt-get install build-essential libssl-dev make nettle-dev curl tzdata -y && \
    rm -rf /var/lib/apt/lists/*
RUN curl -sLo radsecproxy-1.7.1.tar.gz  \
        https://github.com/radsecproxy/radsecproxy/releases/download/1.7.1/radsecproxy-1.7.1.tar.gz && \
    tar xvf radsecproxy-1.7.1.tar.gz && \
    rm radsecproxy-1.7.1.tar.gz &&\
    cd radsecproxy-1.7.1 && \
    curl -fsL -o tests/t_fticks.patch \
        "https://raw.githubusercontent.com/spgreen/eduroam-radsecproxy-docker/master/1.7.1/patch/tests/t_fticks.patch" && \
    echo "$T_FTICKS_PATCH_SHA256 tests/t_fticks.patch" | sha256sum -c - && \
    patch tests/t_fticks.c tests/t_fticks.patch && \
    patch -p1 < /root/radsecproxy-log-opname-cui.diff && \
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
