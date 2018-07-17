#!/bin/bash
##
##请务必先阅读readme
rpm -q screen &> /dev/null
if [ $? -ne 0 ];then
	echo "screen not install"
	echo -e "*********\n1.install screen \n2.screen -S lnmp \n3.bash install_lnmp.sh\n**********"
	exit 1
fi
	
yum -y install wget screen curl python
[ -d /www ] || mkdir /www
cd /www
wget http://mirrors.linuxeye.com/oneinstack-full.tar.gz  
tar -xf oneinstack-full.tar.gz
rm -f oneinstack-full.tar.gz
cd /www/oneinstack
sed -i '/nginx_install/s@/usr/local@/www/server@' options.conf
sed -i '/mysql_install/s@/usr/local@/www/server@' options.conf
sed -i '/php_install/s@/usr/local@/www/server@' options.conf
sed -i '/mysql_data/s@/data/mysql@/www/server/mysql/data@' options.conf
sed -i '/wwwroot_dir/s@/data/wwwroot@/www/wwwroot@' options.conf
sed -i '/wwwlogs_dir/s@/data/wwwlogs@/www/wwwlogs@' options.conf
touch lnmp.sh
echo "#!/bin/bash
bash install.sh << EOF
22
n
y
1
3
5
y
2
Differsql568
1
y
5
n
n
n
n
n
n
n
n
n
EOF" > lnmp.sh
bash lnmp.sh
#####
#  Please input SSH port(Default: 22): 22
#  Do you want to enable iptables? [y/n]:n
#  Do you want to install Web server? [y/n]: y
#  Please input a number:(Default 1 press Enter) 1
#  Please input a number:(Default 3 press Enter) 3
#  Please input a number:(Default 5 press Enter) 5
#  Do you want to install Database? [y/n]: y
#  Please input a number:(Default 2 press Enter):2  //mysql_5.7
#  Please input the root password of MySQL(default: ZXEPAjUb): Differsql568
#  Please input a number:(Default 1 press Enter) 1  //二进制安装
#  Do you want to install PHP? [y/n]: y  
#  Please input a number:(Default 5 press Enter) 5  //php-7.0
#  Do you want to install opcode cache of the PHP? [y/n]: n
#  Do you want to install ionCube? [y/n]: n
#  Do you want to install ImageMagick or GraphicsMagick? [y/n]: n
#  Do you want to install Pure-FTPd? [y/n]: n
#  Do you want to install phpMyAdmin? [y/n]: n
#  Do you want to install redis? [y/n]: n
#  Do you want to install memcached? [y/n]: n
#  Do you want to install HHVM? [y/n]: n
#  Do you want to restart OS ? [y/n]:n

