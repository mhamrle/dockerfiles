FROM ubuntu:14.04

MAINTAINER Filip Gospodinov "filip@monetas.net"

LABEL name=golang-base

ADD postgres/extra.conf  postgres/pg_hba.conf postgres/postgres_superuser.sql /postgres/
ADD postgres/supervisord.conf /etc/supervisor/conf.d/postgres.conf
ADD rabbitmq/dev-supervisord.conf /etc/supervisor/conf.d/rabbitmq.conf
ADD rabbitmq/tests-supervisord.conf /etc/supervisor/conf.d/rabbitmq-tests.conf

ADD install.sh /tmp/
RUN sh /tmp/install.sh

ADD run_services.sh /opt/

# use custom GOPATH such that it does not conflict with GOPATHs that
# live inside the host's $HOME which may be bind mounted into docker
ENV GOPATH /opt/go
ENV GOROOT /opt/go_dist/go
ENV PATH $GOROOT/bin:$GOPATH/bin:$PATH
ADD https://storage.googleapis.com/golang/go1.4.2.linux-amd64.tar.gz /tmp/
ADD dependencies /tmp/
RUN mkdir /opt/go_dist && tar -x -C /opt/go_dist -f /tmp/go1.4.2.linux-amd64.tar.gz
RUN while read dep sha1; do \
        go get "$dep" && cd "$GOPATH/src/$dep" && git checkout "$sha1"; \
    done < /tmp/dependencies
RUN cd $GOPATH/src/github.com/golang/lint/golint && go install
RUN cd $GOPATH/src/github.com/kisielk/errcheck && go install

# InfluxDB and Grafana configuration
# from https://github.com/StackPointCloud/docker-influxdb
ADD metrics/config.js /opt/grafana/config.js
ADD metrics/nginx.conf /etc/nginx/nginx.conf
ADD metrics/supervisord.conf /etc/supervisor/conf.d/metrics.conf
ADD metrics/config.toml /opt/influxdb/current/config.toml

CMD ["bash"]

LABEL version=16
