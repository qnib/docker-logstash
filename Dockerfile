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
RUN yum install -y bsdtar
#### CODECS
# line
RUN echo "" >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-codec-line/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-codec-line", :path => "/opt/logstash-codec-line-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-codec-plain/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-codec-plain", :path => "/opt/logstash-codec-plain-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-codec-json/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-codec-json", :path => "/opt/logstash-codec-json-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-codec-json_lines/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-codec-json_lines", :path => "/opt/logstash-codec-json_lines-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-codec-rubydebug/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-codec-rubydebug", :path => "/opt/logstash-codec-rubydebug-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-codec-oldlogstashjson/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-codec-oldlogstashjson", :path => "/opt/logstash-codec-oldlogstashjson-master/"' >> /opt/logstash/Gemfile 
##### INPUTS
RUN curl -fsL https://github.com/logstash-plugins/logstash-input-stdin/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-input-stdin", :path => "/opt/logstash-input-stdin-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-input-syslog/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-input-syslog", :path => "/opt/logstash-input-syslog-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-input-kafka/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-input-kafka", :path => "/opt/logstash-input-kafka-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-input-udp/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-input-udp", :path => "/opt/logstash-input-udp-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-input-file/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-input-file", :path => "/opt/logstash-input-file-master/"' >> /opt/logstash/Gemfile 
#### FILTERS
RUN curl -fsL https://github.com/logstash-plugins/logstash-filter-zeromq/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-zeromq", :path => "/opt/logstash-filter-zeromq-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-filter-mutate/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-mutate", :path => "/opt/logstash-filter-mutate-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-filter-grok/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-grok", :path => "/opt/logstash-filter-grok-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-filter-date/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-date", :path => "/opt/logstash-filter-date-master/"' >> /opt/logstash/Gemfile && \
    wget -q -O /opt/logstash-filter-geoip.zip https://github.com/logstash-plugins/logstash-filter-geoip/archive/master.zip && \
    curl -fsL https://github.com/logstash-plugins/logstash-filter-geoip/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-geoip", :path => "/opt/logstash-filter-geoip-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-filter-drop/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-drop", :path => "/opt/logstash-filter-drop-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-filter-json/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-json", :path => "/opt/logstash-filter-json-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-filter-ruby/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-filter-ruby", :path => "/opt/logstash-filter-ruby-master/"' >> /opt/logstash/Gemfile 
#### OUTPUTS
# sdtout
RUN curl -fsL https://github.com/logstash-plugins/logstash-output-stdout/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-output-stdout", :path => "/opt/logstash-output-stdout-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-output-elasticsearch/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-output-elasticsearch", :path => "/opt/logstash-output-elasticsearch-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-output-statsd/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-output-statsd", :path => "/opt/logstash-output-statsd-master/"' >> /opt/logstash/Gemfile && \
    curl -fsL https://github.com/logstash-plugins/logstash-output-elasticsearch_http/archive/master.zip |bsdtar xf - -C /opt/ && \
    echo 'gem "logstash-output-elasticsearch_http", :path => "/opt/logstash-output-elasticsearch_http-master/"' >> /opt/logstash/Gemfile
# bootstrap logstash
RUN echo 'gem "thread_safe"' >> /opt/logstash/Gemfile && \
    cd /opt/logstash/ && rake bootstrap
ADD etc/grok/ /etc/grok/

RUN echo "tail -f /var/log/supervisor/logstash.log" >> /root/.bash_history
