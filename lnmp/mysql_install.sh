#!/bin/bash
cd /root
wget http://repo.mysql.com/mysql-community-release-el7-5.noarch.rpm
rpm -ivh mysql-community-release-el7-5.noarch.rpm
yum install -y  mysql-server
chown -R root:root /var/lib/mysql
systemctl start mysqld;systemctl enable mysqld
