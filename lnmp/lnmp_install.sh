#!/bin/bash
# install nginx
rpm -q wget || yum -y install wget 
cd /etc/yum.repos.d
[ -d bak ] || mkdir bak
mv *.repo bak/
wget http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all;yum repolist
cd /root
wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
rpm -ivh nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum clean all;yum repolist
yum -y install nginx
systemctl start nginx;systemctl enable nginx
# install php
rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm
yum -y install php70w
yum install -y  php70w-mysql.x86_64   php70w-gd.x86_64   php70w-ldap.x86_64   php70w-mbstring.x86_64  php70w-mcrypt.x86_64
yum -y install php70w-fpm
systemctl start php-fpm
systemctl enable php-fpm
## install mysql
cd /root
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install -y  mysql-server
chown -R root:root /var/lib/mysql
systemctl start mysqld;systemctl enable mysqld

