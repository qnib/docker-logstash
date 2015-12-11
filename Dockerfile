FROM qnib/terminal

## logstash
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
RUN yum install -y bsdtar git-core python-zmq zeromq czmq && \
    ln -s /usr/lib64/libzmq.so.1 /usr/lib64/libzmq.so && \
    yum install -y ruby rubygem-rake java-1.8.0-openjdk-devel && \
    cd /opt/ && git clone https://github.com/elastic/logstash/

#### free Gemfile from filters in/output
RUN sed -i''  '/gem "logstash-filter.*"/d' /opt/logstash/Gemfile && \
    sed -i'' '/gem "logstash-input.*"/d' /opt/logstash/Gemfile && \
    sed -i'' '/gem "logstash-output.*"/d' /opt/logstash/Gemfile

#### CODECS
# line
RUN echo "" >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-codec-line/ /opt/logstash-codec-line/ && \
    echo 'gem "logstash-codec-line", :path => "/opt/logstash-codec-line/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-codec-plain/ /opt/logstash-codec-plain/ && \
    echo 'gem "logstash-codec-plain", :path => "/opt/logstash-codec-plain/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-codec-json/ /opt/logstash-codec-json/ && \
    echo 'gem "logstash-codec-json", :path => "/opt/logstash-codec-json/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-codec-json_lines/ /opt/logstash-codec-json_lines/ && \
    echo 'gem "logstash-codec-json_lines", :path => "/opt/logstash-codec-json_lines/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-codec-rubydebug/ /opt/logstash-codec-rubydebug/ && \
    echo 'gem "logstash-codec-rubydebug", :path => "/opt/logstash-codec-rubydebug/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-codec-oldlogstashjson/ /opt/logstash-codec-oldlogstashjson/ && \
    echo 'gem "logstash-codec-oldlogstashjson", :path => "/opt/logstash-codec-oldlogstashjson/"' >> /opt/logstash/Gemfile 
##### INPUTS
RUN git clone https://github.com/logstash-plugins/logstash-input-stdin/ /opt/logstash-input-stdin/ && \
    echo 'gem "logstash-input-stdin", :path => "/opt/logstash-input-stdin/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-input-syslog/ /opt/logstash-input-syslog/ && \
    echo 'gem "logstash-input-syslog", :path => "/opt/logstash-input-syslog/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-input-kafka/ /opt/logstash-input-kafka/ && \
    echo 'gem "logstash-input-kafka", :path => "/opt/logstash-input-kafka/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-input-udp/ /opt/logstash-input-udp/ && \
    echo 'gem "logstash-input-udp", :path => "/opt/logstash-input-udp/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-input-file/ /opt/logstash-input-file/ && \
    echo 'gem "logstash-input-file", :path => "/opt/logstash-input-file/"' >> /opt/logstash/Gemfile 

#### FILTERS
RUN git clone https://github.com/logstash-plugins/logstash-filter-zeromq/ /opt/logstash-filter-zeromq/ && \
    echo 'gem "logstash-filter-zeromq", :path => "/opt/logstash-filter-zeromq/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-filter-mutate/ /opt/logstash-filter-mutate/ && \
    echo 'gem "logstash-filter-mutate", :path => "/opt/logstash-filter-mutate/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-filter-grok/ /opt/logstash-filter-grok/ && \
    echo 'gem "logstash-filter-grok", :path => "/opt/logstash-filter-grok/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-filter-date/ /opt/logstash-filter-date/ && \
    echo 'gem "logstash-filter-date", :path => "/opt/logstash-filter-date/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-filter-geoip/ /opt/logstash-filter-geoip/ && \
    echo 'gem "logstash-filter-geoip", :path => "/opt/logstash-filter-geoip/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-filter-drop/ /opt/logstash-filter-drop/ && \
    echo 'gem "logstash-filter-drop", :path => "/opt/logstash-filter-drop/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-filter-json/ /opt/logstash-filter-json && \
    echo 'gem "logstash-filter-json", :path => "/opt/logstash-filter-json/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-filter-ruby/ /opt/logstash-filter-ruby/ && \
    echo 'gem "logstash-filter-ruby", :path => "/opt/logstash-filter-ruby/"' >> /opt/logstash/Gemfile 
#### OUTPUTS
# sdtout
RUN git clone https://github.com/logstash-plugins/logstash-output-stdout/ /opt/logstash-output-stdout/ && \
    echo 'gem "logstash-output-stdout", :path => "/opt/logstash-output-stdout/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-output-elasticsearch/ /opt/logstash-output-elasticsearch/ && \
    echo 'gem "logstash-output-elasticsearch", :path => "/opt/logstash-output-elasticsearch/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-output-statsd/ /opt/logstash-output-statsd/ && \
    echo 'gem "logstash-output-statsd", :path => "/opt/logstash-output-statsd/"' >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-output-elasticsearch_http/ /opt/logstash-output-elasticsearch_http/ && \
    echo 'gem "logstash-output-elasticsearch_http", :path => "/opt/logstash-output-elasticsearch_http/"' >> /opt/logstash/Gemfile
# bootstrap logstash
RUN echo 'gem "thread_safe"' >> /opt/logstash/Gemfile && \
    cd /opt/logstash/ && rake bootstrap
ADD etc/grok/ /etc/grok/

RUN echo "tail -f /var/log/supervisor/logstash.log" >> /root/.bash_history
