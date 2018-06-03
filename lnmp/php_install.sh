#!/bin/bash
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y install php70w
yum install -y  php70w-mysql.x86_64   php70w-gd.x86_64   php70w-ldap.x86_64   php70w-mbstring.x86_64  php70w-mcrypt.x86_64
yum -y install php70w-fpm
