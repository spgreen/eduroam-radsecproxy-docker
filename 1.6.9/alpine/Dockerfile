FROM alpine:3.7
MAINTAINER Simon Green <simonpetergreen@singaren.net.sg>

RUN apk update && apk upgrade
RUN apk add g++ gcc openssl openssl-dev make nettle-dev wget
RUN mkdir -p /opt/radsecproxy && cd /opt/radsecproxy  && \
        wget https://software.nordu.net/radsecproxy/radsecproxy-1.6.9.tar.xz && \
        tar xvf radsecproxy-1.6.9.tar.xz && \
        rm radsecproxy-1.6.9.tar.xz &&\
        cd radsecproxy-1.6.9 && \
        ./configure --enable-fticks --prefix=/ && \
        make && \
        make check && \
        make install && \
        touch /var/log/radsecproxy.log /etc/radsecproxy.conf

ADD env/etc/ /etc/

EXPOSE 1812/udp 1813/udp

ENTRYPOINT /sbin/radsecproxy && tail -f /var/log/radsecproxy.log
