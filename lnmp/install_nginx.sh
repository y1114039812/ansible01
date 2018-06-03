#!/bin/bash
rpm -q wget || yum -y install wget 
cd /root
wget http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm
rpm -ivh nginx-release-centos-7-0.el7.ngx.noarch.rpm
yum clean all;yum repolist
yum -y install nginx
systemctl start nginx;systemctl enable nginx
