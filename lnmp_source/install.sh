#!/bin/bash
yum -y install gcc automake autoconf libtool make gcc-c++ glibc
mkdir -p /www/{packages,server,wwwroot,wwwlogs}
if [ ! -f /root/nginx-1.12.2.tar.gz ];
	echo "安装包不存在，请先拷贝软件包"
	exit 1
fi
install_nginx() {
	groupadd -r www
	useradd -r -g www www
	cd /root
	tar -zxvf pcre-8.41.tar.gz
	tar -zxvf zlib-1.2.11.tar.gz
	tar -zxvf openssl-1.1.0b.tar.gz
	tar -zxvf nginx-1.12.2.tar.gz
	cd nginx-1.12.2/
./configure --prefix=/www/server/nginx --sbin-path=/www/server/nginx/sbin/nginx --conf-path=/www/server/nginx/nginx.conf --pid-path=/www/server/nginx/nginx.pid --user=www --group=www --with-http_ssl_module --with-http_flv_module --with-http_mp4_module  --with-http_stub_status_module --with-select_module --with-poll_module --error-log-path=/www/wwwlogs/nginx/error.log --http-log-path=/www/wwwlogs/nginx/access.log  --with-pcre=/root/pcre-8.41 --with-zlib=/root/zlib-1.2.11 --with-openssl=/root/openssl-1.1.0b
	make 
	make install
	export NGINX_HOME=/www/server/nginx
	export PATH=$PATH:$NGINX_HOME/sbin
	source /etc/profile
	nginx
}
install_php() {
	yum -y install epel-release
	yum -y install libmcrypt-devel mhash-devel libxslt-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel
	cd /root
	tar -xf php-7.1.11.tar.gz
	cd php-7.1.11
	./configure --prefix=/www/server/php --with-config-file-path=/www/server/php/etc --enable-fpm --with-mcrypt --enable-mbstring --enable-pdo --with-curl --disable-debug  --disable-rpath --enable-inline-optimization --with-bz2  --with-zlib --enable-sockets --enable-sysvsem --enable-sysvshm --enable-pcntl --enable-mbregex --with-mhash --enable-zip --with-pcre-regex --with-mysqli --with-gd --with-jpeg-dir --with-freetype-dir --enable-calendar
	make
	make install
	cp /root/php-7.1.11/php.ini-production /www/server/php/etc/php.ini
	cd /www/server/php/etc
	cp php-fpm.conf.default php-fpm.conf
	sed -i "/pid/i pid=/www/server/php/var/run/php-fpm.pid" php-fpm.conf
	cd /www/server/php/etc/php-fpm.d
	cp www.conf.default www.conf
	sed -i "/user =/s@nobody@www@" www.conf
	sed -i "/^group =/s@nobody@www@" www.conf
	sed -i "/^pm.max_ch/c pm.max_children = 100" www.conf
	sed -i "/^pm.start_/c pm.start_servers = 20" www.conf
	sed -i "/^pm.min_sp/c pm.min_spare_servers = 5" www.conf
	sed -i "/^pm.max_sp/c pm.max_spare_servers = 35" www.conf
}	
