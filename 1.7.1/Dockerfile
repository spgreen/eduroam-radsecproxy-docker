FROM ubuntu:18.04
MAINTAINER Simon Green <simonpetergreen@singaren.net.sg>

ENV EXAMPLE_RADSECPROXY_CONF_SHA256 17dfc2c44815c303f298e165a8292c73642f2219b6de5f8d510dce274648dd37
ENV T_FTICKS_PATCH_SHA256 71d38380012479c0905665bbaece8d190521ac10987538ac276a709614d66e00 
WORKDIR /opt

RUN apt-get update && apt-get upgrade -y
RUN apt-get install build-essential openssl libssl-dev make nettle-dev curl libbsd-dev -y
RUN curl -Lo radsecproxy-1.7.1.tar.gz  https://github.com/radsecproxy/radsecproxy/releases/download/1.7.1/radsecproxy-1.7.1.tar.gz && \
	tar xvf radsecproxy-1.7.1.tar.gz && \
	rm radsecproxy-1.7.1.tar.gz &&\
	cd radsecproxy-1.7.1 && \
        curl -fsL -o tests/t_fticks.patch "https://raw.githubusercontent.com/spgreen/eduroam-radsecproxy-docker/master/1.7.1/patch/tests/t_fticks.patch" && \
        echo "$T_FTICKS_PATCH_SHA256 tests/t_fticks.patch" | sha256sum -c - && \
        patch tests/t_fticks.c tests/t_fticks.patch && \
	./configure --prefix=/ && \
	make && \
	make check && \
	make install && \
        touch /var/log/radsecproxy.log && \
        curl -fsL -o radsecproxy.conf "https://raw.githubusercontent.com/spgreen/eduroam-radsecproxy-docker/master/example-configuration/radsecproxy.conf" && \
        echo "$EXAMPLE_RADSECPROXY_CONF_SHA256 *radsecproxy.conf" | sha256sum -c - && \
        mv radsecproxy.conf /etc/radsecproxy.conf

EXPOSE 1812/udp 1813/udp

ENTRYPOINT /sbin/radsecproxy && tail -f /var/log/radsecproxy.log 
