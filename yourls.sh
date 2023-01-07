#!/bin/bash
#docker run --name some-yourls --link some-mysql:mysql \
#    -e YOURLS_SITE="https://9.95118tech" \
#    -e YOURLS_USER="goodway" \
#    -e YOURLS_PASS="Guwei888" \
#    -d yourls
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
  fi
 
# Debian/Ubuntu系统安装PHP 7.4
apt install -y lsb-release gnupg2
wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add -
echo"deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php7.list
apt update
apt install -y php7.4-cli php7.4-fpm php7.4-bcmath php7.4-gd php7.4-mbstring \
php7.4-mysql php7.4-opcache php7.4-xml php7.4-zip php7.4-json php7.4-imagick
update-alternatives --set php /usr/bin/php7.4
# 启动PHP-FPM
systemctl start php7.4-fpm
apt install -y mariadb-server 
systemctl start mariadb
apt install -y nginx
mysql
CREATE USER 用户名@'%' IDENTIFIED BY '密码';
