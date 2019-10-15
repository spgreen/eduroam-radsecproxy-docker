#!/bin/bash

# DEBUG: render radsecproxy log on console if ENVIRONEMNT is TEST

if [ "$ENVIRONMENT" == "TEST" ] ; then
    touch /var/log/radsecproxy/radsecproxy.log
    tail --follow=name /var/log/radsecproxy/radsecproxy.log &
    TAIL_PID=$!
fi

PID_FILE="/var/run/radsecproxy.pid"

/sbin/radsecproxy -i "$PID_FILE"

trap 'echo SIGINT ; kill -INT $( cat $PID_FILE ) $TAIL_PID $SLEEP_PID ; exit' SIGINT
trap 'echo SIGTERM ; kill -TERM $( cat $PID_FILE ) $TAIL_PID $SLEEP_PID ; exit' SIGTERM

while true ; do
    sleep 3600 &
    SLEEP_PID=$!
    wait
done

