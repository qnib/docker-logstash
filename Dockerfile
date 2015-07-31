FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

## logstash
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
RUN yum install -y python-zmq zeromq czmq && \
    ln -s /usr/lib64/libzmq.so.1 /usr/lib64/libzmq.so && \
    yum install -y ruby rubygem-rake java-1.8.0-openjdk-headless && \
    cd /opt/ && wget -q https://github.com/elastic/logstash/archive/master.zip && unzip -q master.zip && \
    mv /opt/logstash-master /opt/logstash && rm -f /opt/master.zip
#### CODECS
# line
RUN wget -q -O /opt/logstash-codec-line.zip https://github.com/logstash-plugins/logstash-codec-line/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-line.zip && rm -f /opt/logstash-codec-line.zip && \
    echo "" >> /opt/logstash/Gemfile && \
    echo 'gem "logstash-codec-line", :path => "/opt/logstash-codec-line-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-codec-plain.zip https://github.com/logstash-plugins/logstash-codec-plain/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-plain.zip && rm -f /opt/logstash-codec-plain.zip && \
    echo 'gem "logstash-codec-plain", :path => "/opt/logstash-codec-plain-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-codec-json.zip https://github.com/logstash-plugins/logstash-codec-json/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-json.zip && rm -f /opt/logstash-codec-json.zip && \
    echo 'gem "logstash-codec-json", :path => "/opt/logstash-codec-json-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-codec-json_lines.zip https://github.com/logstash-plugins/logstash-codec-json_lines/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-json_lines.zip && rm -f /opt/logstash-codec-json_lines.zip && \
    echo 'gem "logstash-codec-json_lines", :path => "/opt/logstash-codec-json_lines-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-codec-rubydebug.zip https://github.com/logstash-plugins/logstash-codec-rubydebug/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-rubydebug.zip && rm -f /opt/logstash-codec-rubydebug.zip && \
    echo 'gem "logstash-codec-rubydebug", :path => "/opt/logstash-codec-rubydebug-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-codec-oldlogstashjson.zip https://github.com/logstash-plugins/logstash-codec-oldlogstashjson/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-codec-oldlogstashjson.zip && rm -f /opt/logstash-codec-oldlogstashjson.zip && \
    echo 'gem "logstash-codec-oldlogstashjson", :path => "/opt/logstash-codec-oldlogstashjson-master/"' >> /opt/logstash/Gemfile 
##### INPUTS
RUN wget -q -O /opt/logstash-input-stdin.zip https://github.com/logstash-plugins/logstash-input-stdin/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-input-stdin.zip && rm -f /opt/logstash-input-stdin.zip && \
    echo 'gem "logstash-input-stdin", :path => "/opt/logstash-input-stdin-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-input-syslog.zip https://github.com/logstash-plugins/logstash-input-syslog/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-input-syslog.zip && rm -f /opt/logstash-input-syslog.zip && \
    echo 'gem "logstash-input-syslog", :path => "/opt/logstash-input-syslog-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-input-kafka.zip https://github.com/logstash-plugins/logstash-input-kafka/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-input-kafka.zip && rm -f /opt/logstash-input-kafka.zip && \
    echo 'gem "logstash-input-kafka", :path => "/opt/logstash-input-kafka-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-input-udp.zip https://github.com/logstash-plugins/logstash-input-udp/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-input-udp.zip && rm -f /opt/logstash-input-udp.zip && \
    echo 'gem "logstash-input-udp", :path => "/opt/logstash-input-udp-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-input-file.zip https://github.com/logstash-plugins/logstash-input-file/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-input-file.zip && rm -f /opt/logstash-input-file.zip && \
    echo 'gem "logstash-input-file", :path => "/opt/logstash-input-file-master/"' >> /opt/logstash/Gemfile 
#### FILTERS
RUN wget -q -O /opt/logstash-filter-zeromq.zip https://github.com/barravi/logstash-filter-zeromq/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-zeromq.zip && rm -f /opt/logstash-filter-zeromq.zip && \
    echo 'gem "logstash-filter-zeromq", :path => "/opt/logstash-filter-zeromq-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-mutate.zip https://github.com/logstash-plugins/logstash-filter-mutate/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-mutate.zip && rm -f /opt/logstash-filter-mutate.zip && \
    echo 'gem "logstash-filter-mutate", :path => "/opt/logstash-filter-mutate-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-grok.zip https://github.com/logstash-plugins/logstash-filter-grok/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-grok.zip && rm -f /opt/logstash-filter-grok.zip && \
    echo 'gem "logstash-filter-grok", :path => "/opt/logstash-filter-grok-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-date.zip https://github.com/logstash-plugins/logstash-filter-date/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-date.zip && rm -f /opt/logstash-filter-date.zip && \
    echo 'gem "logstash-filter-date", :path => "/opt/logstash-filter-date-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-geoip.zip https://github.com/logstash-plugins/logstash-filter-geoip/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-geoip.zip && rm -f /opt/logstash-filter-geoip.zip && \
    echo 'gem "logstash-filter-geoip", :path => "/opt/logstash-filter-geoip-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-drop.zip https://github.com/logstash-plugins/logstash-filter-drop/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-drop.zip && rm -f /opt/logstash-filter-drop.zip && \
    echo 'gem "logstash-filter-drop", :path => "/opt/logstash-filter-drop-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-json.zip https://github.com/logstash-plugins/logstash-filter-json/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-json.zip && rm -f /opt/logstash-filter-json.zip && \
    echo 'gem "logstash-filter-json", :path => "/opt/logstash-filter-json-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-ruby.zip https://github.com/logstash-plugins/logstash-filter-ruby/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-ruby.zip && rm -f /opt/logstash-filter-ruby.zip && \
    echo 'gem "logstash-filter-ruby", :path => "/opt/logstash-filter-ruby-master/"' >> /opt/logstash/Gemfile 
#### OUTPUTS
# sdtout
RUN wget -q -O /opt/logstash-output-stdout.zip https://github.com/logstash-plugins/logstash-output-stdout/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-stdout.zip && rm -f /opt/logstash-output-stdout.zip && \
    echo 'gem "logstash-output-stdout", :path => "/opt/logstash-output-stdout-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-output-elasticsearch.zip https://github.com/logstash-plugins/logstash-output-elasticsearch/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-elasticsearch.zip && rm -f /opt/logstash-output-elasticsearch.zip && \
    echo 'gem "logstash-output-elasticsearch", :path => "/opt/logstash-output-elasticsearch-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-output-statsd.zip https://github.com/logstash-plugins/logstash-output-statsd/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-statsd.zip && rm -f /opt/logstash-output-statsd.zip && \
    echo 'gem "logstash-output-statsd", :path => "/opt/logstash-output-statsd-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-output-elasticsearch_http.zip https://github.com/logstash-plugins/logstash-output-elasticsearch_http/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-output-elasticsearch_http.zip && rm -f /opt/logstash-output-elasticsearch_http.zip && \
    echo 'gem "logstash-output-elasticsearch_http", :path => "/opt/logstash-output-elasticsearch_http-master/"' >> /opt/logstash/Gemfile
# bootstrap logstash
RUN echo 'gem "thread_safe"' >> /opt/logstash/Gemfile && \
    cd /opt/logstash/ && rake bootstrap
ADD etc/grok/ /etc/grok/

RUN echo "tail -f /var/log/supervisor/logstash.log" >> /root/.bash_history
