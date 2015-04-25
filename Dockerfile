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
    cp /opt/logstash_rpm/lib/logstash/outputs/{elasticsearch.rb,stdout.rb} /opt/logstash/lib/logstash/outputs/ && \
    cp /opt/logstash_rpm/lib/logstash/codecs/{json.rb,line.rb,plain.rb,json_lines.rb} /opt/logstash/lib/logstash/codecs/
# zeromq
RUN wget -q -O /opt/logstash-filter-zeromq.zip https://github.com/barravi/logstash-filter-zeromq/archive/master.zip && \
    cd /opt/ && unzip -q /opt/logstash-filter-zeromq.zip && rm -f /opt/logstash-filter-zeromq.zip && \
    echo 'gem "logstash-filter-zeromq", :path => "/opt/logstash-filter-zeromq-master/"' >> /opt/logstash/Gemfile

# bootstrap logstash
#RUN cd /opt/logstash/ && rake bootstrap
