FROM centos:7

LABEL MAINTAINER="admin@diendannhatban.info"

RUN yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN yum install -y http://rpms.remirepo.net/enterprise/remi-release-7.rpm

# Dependencies
RUN yum update -y
RUN yum install -y httpd yum-utils

# RUN yum-config-manager --enable remi-php70
# RUN yum-config-manager --enable remi-php71
RUN yum-config-manager --enable remi-php72

RUN yum install --enablerepo=epel -y \
  php \
  php-mcrypt \
  php-cli \
  php-gd \
  php-curl \
  php-mysql \
  php-ldap \
  php-zip \
  php-fileinfo 

RUN sed -i -e "s|^;date.timezone =.*$|date.timezone = Asia/Tokyo|" /etc/php.ini

# Default Docker Dev
COPY site.conf /etc/httpd/conf.d/site.conf
# TODO: allow exclude cp !()
RUN shopt -s extglob

ENV HOME /root

EXPOSE 8000

CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]