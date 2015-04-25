FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

ADD etc/yum.repos.d/logstash-1.4.repo /etc/yum.repos.d/

# logstash
RUN yum install -y logstash 
RUN yum install -y logstash-contrib
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
RUN mv /opt/logstash/ /opt/logstash_rpm
RUN yum install -y python-zmq zeromq czmq && \
    ln -s /usr/lib64/libzmq.so.1 /usr/lib64/libzmq.so
RUN yum install -y ruby rubygem-rake
# logstash
RUN cd /opt/ && wget -q https://github.com/elastic/logstash/archive/master.zip && unzip -q master.zip && \
    mv /opt/logstash-master /opt/logstash && rm -f /opt/master.zip
RUN cp /opt/logstash_rpm/lib/logstash/inputs/{syslog.rb,stdin.rb} /opt/logstash/lib/logstash/inputs/ && \
    cp /opt/logstash_rpm/lib/logstash/outputs/stdout.rb /opt/logstash/lib/logstash/outputs/ && \
    cp /opt/logstash_rpm/lib/logstash/codecs/{json.rb,line.rb,plain.rb,json_lines.rb} /opt/logstash/lib/logstash/codecs/
# zeromq
RUN wget -q -O /opt/logstash-filter-zeromq.zip https://github.com/barravi/logstash-filter-zeromq/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-zeromq.zip && rm -f /opt/logstash-filter-zeromq.zip && \
    echo 'gem "logstash-filter-zeromq", :path => "/opt/logstash-filter-zeromq-master/"' >> /opt/logstash/Gemfile
# elasticsearch
RUN wget -q -O /opt/logstash-output-elasticsearch.zip https://github.com/logstash-plugins/logstash-output-elasticsearch/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-elasticsearch.zip && rm -f /opt/logstash-output-elasticsearch.zip && \
    echo 'gem "logstash-output-elasticsearch", :path => "/opt/logstash-output-elasticsearch-master/"' >> /opt/logstash/Gemfile
# mutate
RUN wget -q -O /opt/logstash-filter-mutate.zip https://github.com/logstash-plugins/logstash-filter-mutate/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-mutate.zip && rm -f /opt/logstash-filter-mutate.zip && \
    echo 'gem "logstash-filter-mutate", :path => "/opt/logstash-filter-mutate-master/"' >> /opt/logstash/Gemfile
# grok
RUN wget -q -O /opt/logstash-filter-grok.zip https://github.com/logstash-plugins/logstash-filter-grok/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-grok.zip && rm -f /opt/logstash-filter-grok.zip && \
    echo 'gem "logstash-filter-grok", :path => "/opt/logstash-filter-grok-master/"' >> /opt/logstash/Gemfile
# bootstrap logstash
RUN echo 'gem "thread_safe"' >> /opt/logstash/Gemfile
RUN cd /opt/logstash/ && rake bootstrap
RUN cp /opt/logstash_rpm/lib/logstash/outputs/elasticsearch_http.rb /opt/logstash/lib/logstash/outputs/ && \
    cp /opt/logstash_rpm/lib/logstash/filters/date.rb /opt/logstash/lib/logstash/filters/
ADD etc/grok/ /etc/grok/
