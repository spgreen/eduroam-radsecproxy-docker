FROM alpine:3.7
MAINTAINER Simon Green <simonpetergreen@singaren.net.sg>

ENV EXAMPLE_RADSECPROXY_CONF_SHA256 17dfc2c44815c303f298e165a8292c73642f2219b6de5f8d510dce274648dd37
WORKDIR /opt


RUN apk update && apk upgrade
RUN apk add g++ gcc openssl openssl-dev make nettle-dev curl
RUN curl -Lo radsecproxy-1.6.9.tar.gz  https://github.com/radsecproxy/radsecproxy/releases/download/radsecproxy-1.6.9/radsecproxy-1.6.9.tar.gz && \
	tar xvf radsecproxy-1.6.9.tar.gz && \
	rm radsecproxy-1.6.9.tar.gz &&\
	cd radsecproxy-1.6.9 && \
	./configure --enable-fticks --prefix=/ && \
	make && \
	make check && \
	make install && \
        touch /var/log/radsecproxy.log && \
        curl -fsL -o radsecproxy.conf "https://raw.githubusercontent.com/spgreen/eduroam-radsecproxy-docker/master/example-configuration/radsecproxy.conf" && \
        echo "$EXAMPLE_RADSECPROXY_CONF_SHA256 *radsecproxy.conf" | sha256sum -c - && \
        mv radsecproxy.conf /etc/radsecproxy.conf

EXPOSE 1812/udp 1813/udp

ENTRYPOINT /sbin/radsecproxy && tail -f /var/log/radsecproxy.log 
