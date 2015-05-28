FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

ADD etc/yum.repos.d/logstash-1.4.repo /etc/yum.repos.d/

## logstash
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
RUN yum install -y python-zmq zeromq czmq && \
    ln -s /usr/lib64/libzmq.so.1 /usr/lib64/libzmq.so
RUN yum install -y ruby rubygem-rake
# logstash
RUN cd /opt/ && wget -q https://github.com/elastic/logstash/archive/master.zip && unzip -q master.zip && \
    mv /opt/logstash-master /opt/logstash && rm -f /opt/master.zip
#### CODECS
# line
RUN wget -q -O /opt/logstash-codec-line.zip https://github.com/logstash-plugins/logstash-codec-line/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-line.zip && rm -f /opt/logstash-codec-line.zip && \
    echo 'gem "logstash-codec-line", :path => "/opt/logstash-codec-line-master/"' >> /opt/logstash/Gemfile
# plain
RUN wget -q -O /opt/logstash-codec-plain.zip https://github.com/logstash-plugins/logstash-codec-plain/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-plain.zip && rm -f /opt/logstash-codec-plain.zip && \
    echo 'gem "logstash-codec-plain", :path => "/opt/logstash-codec-plain-master/"' >> /opt/logstash/Gemfile
# json
RUN wget -q -O /opt/logstash-codec-json.zip https://github.com/logstash-plugins/logstash-codec-json/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-json.zip && rm -f /opt/logstash-codec-json.zip && \
    echo 'gem "logstash-codec-json", :path => "/opt/logstash-codec-json-master/"' >> /opt/logstash/Gemfile
# json_lines
RUN wget -q -O /opt/logstash-codec-json_lines.zip https://github.com/logstash-plugins/logstash-codec-json_lines/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-json_lines.zip && rm -f /opt/logstash-codec-json_lines.zip && \
    echo 'gem "logstash-codec-json_lines", :path => "/opt/logstash-codec-json_lines-master/"' >> /opt/logstash/Gemfile
#### INPUTS
# syslog
RUN wget -q -O /opt/logstash-input-stdin.zip https://github.com/logstash-plugins/logstash-input-stdin/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-input-stdin.zip && rm -f /opt/logstash-input-stdin.zip && \
    echo 'gem "logstash-input-stdin", :path => "/opt/logstash-input-stdin-master/"' >> /opt/logstash/Gemfile
# stdin
RUN wget -q -O /opt/logstash-input-syslog.zip https://github.com/logstash-plugins/logstash-input-syslog/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-input-syslog.zip && rm -f /opt/logstash-input-syslog.zip && \
    echo 'gem "logstash-input-syslog", :path => "/opt/logstash-input-syslog-master/"' >> /opt/logstash/Gemfile
#### FILTERS
# zeromq
RUN wget -q -O /opt/logstash-filter-zeromq.zip https://github.com/barravi/logstash-filter-zeromq/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-zeromq.zip && rm -f /opt/logstash-filter-zeromq.zip && \
    echo 'gem "logstash-filter-zeromq", :path => "/opt/logstash-filter-zeromq-master/"' >> /opt/logstash/Gemfile
# mutate
RUN wget -q -O /opt/logstash-filter-mutate.zip https://github.com/logstash-plugins/logstash-filter-mutate/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-mutate.zip && rm -f /opt/logstash-filter-mutate.zip && \
    echo 'gem "logstash-filter-mutate", :path => "/opt/logstash-filter-mutate-master/"' >> /opt/logstash/Gemfile
# grok
RUN wget -q -O /opt/logstash-filter-grok.zip https://github.com/logstash-plugins/logstash-filter-grok/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-grok.zip && rm -f /opt/logstash-filter-grok.zip && \
    echo 'gem "logstash-filter-grok", :path => "/opt/logstash-filter-grok-master/"' >> /opt/logstash/Gemfile
# date
RUN wget -q -O /opt/logstash-filter-date.zip https://github.com/logstash-plugins/logstash-filter-date/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-date.zip && rm -f /opt/logstash-filter-date.zip && \
    echo 'gem "logstash-filter-date", :path => "/opt/logstash-filter-date-master/"' >> /opt/logstash/Gemfile
# drop
RUN wget -q -O /opt/logstash-filter-drop.zip https://github.com/logstash-plugins/logstash-filter-drop/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-drop.zip && rm -f /opt/logstash-filter-drop.zip && \
    echo 'gem "logstash-filter-drop", :path => "/opt/logstash-filter-drop-master/"' >> /opt/logstash/Gemfile
# json
RUN wget -q -O /opt/logstash-filter-json.zip https://github.com/logstash-plugins/logstash-filter-json/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-json.zip && rm -f /opt/logstash-filter-json.zip && \
    echo 'gem "logstash-filter-json", :path => "/opt/logstash-filter-json-master/"' >> /opt/logstash/Gemfile
#### OUTPUTS
# sdtout
RUN wget -q -O /opt/logstash-output-stdout.zip https://github.com/logstash-plugins/logstash-output-stdout/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-stdout.zip && rm -f /opt/logstash-output-stdout.zip && \
    echo 'gem "logstash-output-stdout", :path => "/opt/logstash-output-stdout-master/"' >> /opt/logstash/Gemfile
# elasticsearch
RUN wget -q -O /opt/logstash-output-elasticsearch.zip https://github.com/logstash-plugins/logstash-output-elasticsearch/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-elasticsearch.zip && rm -f /opt/logstash-output-elasticsearch.zip && \
    echo 'gem "logstash-output-elasticsearch", :path => "/opt/logstash-output-elasticsearch-master/"' >> /opt/logstash/Gemfile
# elasticsearch_http
RUN wget -q -O /opt/logstash-output-elasticsearch_http.zip https://github.com/logstash-plugins/logstash-output-elasticsearch_http/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-elasticsearch_http.zip && rm -f /opt/logstash-output-elasticsearch_http.zip && \
    echo 'gem "logstash-output-elasticsearch_http", :path => "/opt/logstash-output-elasticsearch_http-master/"' >> /opt/logstash/Gemfile
# bootstrap logstash
RUN echo 'gem "thread_safe"' >> /opt/logstash/Gemfile
RUN yum install -y java-1.7.0-openjdk
RUN cd /opt/logstash/ && rake bootstrap
ADD etc/grok/ /etc/grok/
