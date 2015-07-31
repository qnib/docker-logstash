# docker-logstash

[![](https://badge.imagelayers.io/qnib/logstash:latest.svg)](https://imagelayers.io/?images=qnib/logstash:latest 'Details')
[![](https://badge.imagelayers.io/qnib/logstash:trunk.svg)](https://imagelayers.io/?images=qnib/logstash:trunk 'Details')

Image to take events in and pump them into Redis server (to be picked-up by 'real' elk instance).

## Using it
To push logs into it just fire up the fig config:
```
~/git/docker-logstash $ fig up -d
Creating dockerlogstash_logstash_1...
~/git/docker-logstash $
```
After a couple of seconds logstash and redis should be up and running. To test it we are going to send a Log to Logstash and receive the latest
log within redis (RPOP: right pop).
```
~/git/docker-logstash $ echo "TestLog1"|nc -w1 192.168.59.103 5514
~/git/docker-logstash $ redis-cli -h 192.168.59.103 RPOP logstash-syslog
"{\"message\":\"TestLog1\\n\",\"@version\":\"1\",\"@timestamp\":\"2015-02-17T09:31:27.159Z\",\"type\":\"syslog\",\"host\":\"192.168.59.3\",\"tags\":[\"_grokparsefailure\"],\"priority\":13,\"severity\":5,\"facility\":1,\"facility_label\":\"user-level\",\"severity_label\":\"Notice\"}"
```
