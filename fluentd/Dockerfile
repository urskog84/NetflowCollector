FROM fluent/fluentd:latest
RUN fluent-gem install fluent-plugin-netflow
RUN fluent-gem install fluent-plugin-influxdb -v "~> 0.3"  --no-document
COPY ./fluentd.conf /fluentd/etc/fluent.conf
