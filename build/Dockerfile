FROM fedora/sssd

MAINTAINER moresandeep

RUN yum install -y openldap-clients nss-pam-ldapd unzip wget

### Install Java ###
ENV JAVA_VERSION 8u31
ENV BUILD_VERSION b13

RUN wget --no-cookies --no-check-certificate --header "Cookie: oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/$JAVA_VERSION-$BUILD_VERSION/jdk-$JAVA_VERSION-linux-x64.rpm" -O /tmp/jdk-8-linux-x64.rpm

RUN yum -y install /tmp/jdk-8-linux-x64.rpm

RUN alternatives --install /usr/bin/java jar /usr/java/latest/bin/java 200000
RUN alternatives --install /usr/bin/javaws javaws /usr/java/latest/bin/javaws 200000
RUN alternatives --install /usr/bin/javac javac /usr/java/latest/bin/javac 200000

ENV JAVA_HOME /usr/java/latest
### Done install Java ###

# Setup LDAP
RUN mkdir /knox
RUN mkdir /knox/bin
RUN mkdir /knox/conf
RUN mkdir /knox/lib

ADD sssd.conf /etc/sssd/sssd.conf
ADD init.sh /init.sh

RUN chmod 600 /etc/sssd/sssd.conf
RUN chmod +x /init.sh

# RUN export TLS_CACERTDIR=/knox/certs/

# Update SSSD to make it find our LDAP
RUN authconfig --enablesssd --enablesssdauth --enablelocauthorize --enableldap --enableldapauth --ldapserver=ldap --enableldaptls --ldapbasedn=dc=apache,dc=org --enableshadow --enablerfc2307bis --enablemkhomedir --enablecachecreds --update

# Install Knox
RUN curl -O http://mirror.cogentco.com/pub/apache/knox/0.10.0/knox-0.10.0.zip 
RUN unzip /knox-0.10.0.zip -d /knox

ADD knox/topologies/sandbox.xml /knox/knox-0.10.0/conf/topologies/sandbox.xml
ADD knox/services/ /knox/knox-0.10.0/data/services/
ADD master /knox/knox-0.10.0/data/security/master

RUN chmod -R +x /knox/knox-0.10.0/data/services/weather
RUN chmod -R +x /knox/knox-0.10.0/bin/

RUN export TERM=dumb

