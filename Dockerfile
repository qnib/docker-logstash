FROM qnib/terminal

## logstash
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
RUN yum clean all && \
    yum install -y bsdtar git-core python-zmq zeromq czmq \
                   ruby rubygem-rake
RUN yum install -y java-1.8.0-openjdk-devel
RUN cd /opt/ && git clone -b 2.1 https://github.com/elastic/logstash/

#### free Gemfile from filters in/output
RUN sed -i''  '/gem "logstash-filter.*"/d' /opt/logstash/Gemfile && \
    sed -i'' '/gem "logstash-input.*"/d' /opt/logstash/Gemfile && \
    sed -i'' '/gem "logstash-output.*"/d' /opt/logstash/Gemfile && \
    sed -i'' '/gem "logstash-codec.*"/d' /opt/logstash/Gemfile

#### CODECS
# line
RUN echo "" >> /opt/logstash/Gemfile && \
    git clone https://github.com/logstash-plugins/logstash-codec-rubydebug/ /opt/logstash-codec-rubydebug/ && \
    echo 'gem "logstash-codec-rubydebug", :path => "/opt/logstash-codec-rubydebug/"' >> /opt/logstash/Gemfile
##### INPUTS
RUN git clone https://github.com/logstash-plugins/logstash-input-stdin/ /opt/logstash-input-stdin/ && \
    echo 'gem "logstash-input-stdin", :path => "/opt/logstash-input-stdin/"' >> /opt/logstash/Gemfile 

#### FILTERS
RUN git clone https://github.com/logstash-plugins/logstash-filter-zeromq/ /opt/logstash-filter-zeromq/ && \
    echo 'gem "logstash-filter-zeromq", :path => "/opt/logstash-filter-zeromq/"' >> /opt/logstash/Gemfile 
#### OUTPUTS
# sdtout
RUN git clone https://github.com/logstash-plugins/logstash-output-stdout/ /opt/logstash-output-stdout/ && \
    echo 'gem "logstash-output-stdout", :path => "/opt/logstash-output-stdout/"' >> /opt/logstash/Gemfile

# bootstrap logstash
RUN echo 'gem "thread_safe"' >> /opt/logstash/Gemfile && \
    cd /opt/logstash/ && rake bootstrap
ADD etc/grok/ /etc/grok/

RUN echo "tail -f /var/log/supervisor/logstash.log" >> /root/.bash_history && \
    echo "python /data/server.py &" >> /root/.bash_history && \
    echo "/opt/logstash/bin/logstash -f /data/all.config" >> /root/.bash_history 
ADD tmp/* /data/
