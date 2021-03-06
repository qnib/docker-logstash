FROM qnib/java8

ADD etc/yum.repos.d/logstash.repo /etc/yum.repos.d/

# logstash
RUN echo "2015-05-28.1" && yum clean all &&  \
    useradd jls && \
    dnf install -y jq bc && \
    rpm --import https://packages.elastic.co/GPG-KEY-elasticsearch && \
    dnf install -y logstash && \
    /opt/logstash/bin/plugin install \
         logstash-codec-oldlogstashjson \
         logstash-input-elasticsearch \
         logstash-input-tcp \
         logstash-input-udp \
         logstash-input-syslog \
         logstash-filter-grok \
         logstash-filter-mutate \
         logstash-filter-zeromq \
         logstash-output-elasticsearch \
         logstash-output-kafka
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
