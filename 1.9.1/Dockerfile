FROM alpine:3.13
MAINTAINER Simon Green <simonpetergreen@singaren.net.sg>

ENV RADSECPROXY_VERSION 1.9.1
ENV TZ UTC

# Fabian Mauchle PGP Key Fingerprint found at https://radsecproxy.github.io/

WORKDIR /opt

COPY run.sh /opt/
RUN apk update && apk upgrade && \
    apk --no-cache --update add --virtual build-dependencies build-base curl gnupg && \
    apk --no-cache add tzdata nettle-dev openssl-dev && \
    adduser -D -u 52000 radsecproxy && \
    curl -sLo radsecproxy-${RADSECPROXY_VERSION}.tar.gz  \
        https://github.com/radsecproxy/radsecproxy/releases/download/${RADSECPROXY_VERSION}/radsecproxy-${RADSECPROXY_VERSION}.tar.gz && \
    curl  -sLo radsecproxy-${RADSECPROXY_VERSION}.tar.gz.asc \
        https://github.com/radsecproxy/radsecproxy/releases/download/${RADSECPROXY_VERSION}/radsecproxy-${RADSECPROXY_VERSION}.tar.gz.asc && \
    curl -sS https://radsecproxy.github.io/fabian.mauchle.asc | gpg --import - && \
    gpg --verify radsecproxy-${RADSECPROXY_VERSION}.tar.gz.asc \
                 radsecproxy-${RADSECPROXY_VERSION}.tar.gz && \
    rm  radsecproxy-${RADSECPROXY_VERSION}.tar.gz.asc && \
    tar xvf radsecproxy-${RADSECPROXY_VERSION}.tar.gz && \
    rm radsecproxy-${RADSECPROXY_VERSION}.tar.gz &&\
    cd radsecproxy-${RADSECPROXY_VERSION} && \
    ./configure --prefix=/ && \
    make && \
    make check && \
    make install && \
    mkdir /var/log/radsecproxy/ /var/run/radsecproxy && \
    touch /var/log/radsecproxy/radsecproxy.log && \
    chown -R radsecproxy:radsecproxy /var/log/radsecproxy /var/run/radsecproxy && \
    apk del build-dependencies && \
    rm -rf /etc/apk/* /var/cache/apk/* /tmp/* /root/.gnupg && \
    rm -r /opt/radsecproxy-${RADSECPROXY_VERSION}

USER radsecproxy

EXPOSE 1812/udp 1813/udp

CMD ["/opt/run.sh"]
