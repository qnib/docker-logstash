#!/bin/bash

sleep 1

# function to start logstash via supervisord and wait for the lock-file to disappear
function watch_lock {
    while [ true ];do
        if [ ! -f /etc/logstash/conf.d/remove_to_restart_logstash ];then
            echo "## lockfile missing -> restart logstash"
            touch /etc/logstash/conf.d/remove_to_restart_logstash
            supervisorctl restart logstash
        fi
        sleep 1
    done
}


##### logstash conf bt default is empty.
# it might be mapped from the host
# if no config is given it is prefilled with the default
if [ $(find /etc/logstash/conf.d/ -name \*.conf|wc -l) -eq 0 ];then
    echo "## Logstash/conf.d empty. Copying default config..."
    echo "cp /etc/default/logstash/*.conf /etc/logstash/conf.d/"
    cp /etc/default/logstash/*.conf /etc/logstash/conf.d/
fi

### check inputs to remove checks
CONSUL_RELOAD=0
if [ $(grep -A3 "syslog {"  /etc/logstash/conf.d/*.conf |grep -c 5514) -eq 0 ];then 
    rm -f /etc/consul.d/logstash_syslog.json
    CONSUL_RELOAD=1
fi
if [ $(grep -A3 "udp {"  /etc/logstash/conf.d/*.conf |grep -c 55514) -eq 0 ];then 
    rm -f /etc/consul.d/logstash_udp.json
    CONSUL_RELOAD=1
fi
if [ ${CONSUL_RELOAD} -eq 1 ];then
    consul reload
fi

## Start logstash watchdog
rm -f /etc/logstash/conf.d/remove_to_restart_logstash
watch_lock


