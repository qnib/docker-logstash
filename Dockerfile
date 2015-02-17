FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

ADD etc/yum.repos.d/logstash-1.4.repo /etc/yum.repos.d/

# logstash
RUN useradd jls && \
    yum install -y logstash
ADD etc/default/logstash /etc/default/logstash
ADD etc/consul.d/ /etc/consul.d/
ADD etc/syslog-ng/conf.d/logstash.conf /etc/syslog-ng/conf.d/logstash.conf

# Redis
RUN yum install -y redis python-redis
ADD etc/diamond/collectors/RedisCollector.conf /etc/diamond/collectors/

# Add key,cert
ADD etc/pki/tls/certs/logstash-forwarder.crt /etc/pki/tls/certs/
ADD etc/pki/tls/private/logstash-forwarder.key /etc/pki/tls/private/

# Should move to terminal
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/

# move up
RUN mkdir -p /root/bin/ && \
    ln -s /opt/qnib/bin/* /root/bin/
