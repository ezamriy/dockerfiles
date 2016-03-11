FROM centos:centos7

MAINTAINER Eugene Zamriy <eugene@zamriy.info>

ADD ./mongodb-org-3.2.repo /etc/yum.repos.d/

RUN yum -y update && \
    yum -y install mongodb-org-server mongodb-org-shell mongodb-org-tools && \
    yum clean all && \
    mkdir -p /var/lib/mongo && \
    chown -R mongod:mongod /var/lib/mongo

VOLUME ["/var/lib/mongo"]

EXPOSE 27017

CMD ["/usr/bin/mongod", "--dbpath", "/var/lib/mongo"]
