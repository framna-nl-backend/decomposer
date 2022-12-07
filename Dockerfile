FROM centos:centos7
MAINTAINER sean.molenaar@moveagency.com
WORKDIR /tmp/decomposer
COPY . .

RUN yum -y install epel-release
RUN yum -y install make scdoc man jq git
RUN make doc install

ENTRYPOINT ["/usr/bin/decomposer"]
WORKDIR /var/www/project
RUN rm -rf /tmp/decomposer
RUN mkdir /var/www/libs
