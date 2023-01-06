#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
if [ $(whoami) != "root" ];then
	echo "请使用root权限执行！"
	exit 1;
fi

is64bit=$(getconf LONG_BIT)
if [ "${is64bit}" != '64' ];then
	Red_Error "抱歉, 不支持32位系统, 请使用64位系统!";
fi

Centos6Check=$(cat /etc/redhat-release | grep ' 6.' | grep -iE 'centos|Red Hat')
if [ "${Centos6Check}" ];then
	#	echo "Centos6不支持安装宝塔面板，请更换Centos7/8安装宝塔面板"
	#CentOS 6
	rpm -iUvh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
	yum update -y
	yum -y install docker-io
	service docker start
	chkconfig docker on
	exit 1
fi 

UbuntuCheck=$(cat /etc/issue|grep Ubuntu|awk '{print $2}'|cut -f 1 -d '.')
if [ "${UbuntuCheck}" ] && [ "${UbuntuCheck}" -lt "16" ];then
	echo "Ubuntu ${UbuntuCheck}不支持安装，建议更换Ubuntu18/20安装"
	exit 1
fi

#CentOS 7、Debian、Ubuntu
curl -sSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker
docker run --restart always --name fast -p 89:8081 -d -v /var/run/docker.sock:/var/run/docker.sock wangbinxingkong/fast
echo "http://服务器IP地址或域名:89 默认账号:admin 密码:888888"
