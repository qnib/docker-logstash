FROM qnib/java8

ADD etc/yum.repos.d/logstash.repo /etc/yum.repos.d/

# logstash
RUN echo "2015-05-28.1" && yum clean all &&  \
    useradd jls && \
    yum install -y logstash && \
    /opt/logstash/bin/plugin install \
         logstash-input-tcp \
         logstash-input-udp \
         logstash-input-syslog \
         logstash-filter-grok \
         logstash-filter-mutate \
         logstash-output-elasticsearch \
         logstash-output-kafka
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
