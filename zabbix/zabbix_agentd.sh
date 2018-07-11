#!/bin/bash
yum -y install gcc gcc-c++
useradd -s /sbin/nologin zabbix
cd /root
if [ ! -f zabbix-3.2.3.tar.gz ];then
	echo "zabbix-3.2.3.tar.gz 不存在."
	exit 1
fi
tar -xf zabbix-3.2.3.tar.gz
cd zabbix-3.2.3
./configure --enable-agent --prefix=/usr/local/zabbix
make && make install
ln -s /usr/local/zabbix/etc/ /etc/zabbix
mkdir /var/log/zabbix
chown zabbix.zabbix /var/log/zabbix
cp /root/zabbix-3.2.3/misc/init.d/fedora/core/zabbix_agentd /etc/init.d/
chmod 755 /etc/init.d/zabbix_agentd
ln -s /usr/local/zabbix/etc /etc/zabbix
ln -s /usr/local/zabbix/bin/* /usr/bin/
ln -s /usr/local/zabbix/sbin/* /usr/sbin/
## change zabbix_agentd.conf
sed -i "/^Server=/c Server=127.0.0.1,118.184.0.184"  /etc/zabbix/zabbix_agentd.conf
sed -i "/^ServerActive=/c ServerActive=118.184.0.184:10051"  /etc/zabbix/zabbix_agentd.conf
sed -i "/^LogFile=/s@/tmp@/var/log/zabbix@"  /etc/zabbix/zabbix_agentd.conf
sed -i "/UnsafeUserParameters=/c UnsafeUserParameters=1"  /etc/zabbix/zabbix_agentd.conf
## change /etc/init.d/zabbix_agentd
sed -i "/BASEDIR=/s@/usr/local@&/zabbix@"  /etc/init.d/zabbix_agentd
chkconfig zabbix_agentd on
service zabbix_agentd start

## define
echo "
#!/bin/bash
ss -anptu | grep ':80' | wc -l " > /usr/local/sbin/my_web80_count.sh
chmod 755 /usr/local/sbin/my_web80_count.sh
echo "UserParameter=my.web80.count[*],/usr/local/sbin/my_web80_count.sh" >> /etc/zabbix/zabbix_agentd.conf
echo "
#!/bin/bash
ss -anptu | grep ':80' | grep -c ESTAB " > /usr/local/sbin/my_estab_count.sh
chmod 755 /usr/local/sbin/my_estab_count.sh
echo "UserParameter=my.estab.count[*],/usr/local/sbin/my_estab_count.sh" >> /etc/zabbix/zabbix_agentd.conf
echo "
#!/bin/bash
who |wc -l " > /usr/local/sbin/my_login_count.sh
chmod 755 /usr/local/sbin/my_login_count.sh
echo "UserParameter=my.login.count[*],/usr/local/sbin/my_login_count.sh" >> /etc/zabbix/zabbix_agentd.conf

service zabbix_agentd restart
