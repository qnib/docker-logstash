FROM qnib/terminal
MAINTAINER "Christian Kniep <christian@qnib.org>"

ADD etc/yum.repos.d/logstash-1.5.repo /etc/yum.repos.d/

# logstash
RUN echo "2015-05-28.1" && yum clean all &&  \
    useradd jls && \
    yum install -y logstash
ADD opt/qnib/bin/ /opt/qnib/bin/
ADD etc/supervisord.d/ /etc/supervisord.d/
ADD etc/consul.d/ /etc/consul.d/
