#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8

Btapi_Url='https://bt.vpnkol.com'
Check_Api=$(curl -Ss --connect-timeout 5 -m 2 $Btapi_Url/api/SetupCount)
if [ "$Check_Api" != 'ok' ];then
	Red_Error "此宝塔第三方云端无法连接，因此安装过程已中止！";
fi

if [ $(whoami) != "root" ];then
	echo "请使用root权限执行宝塔安装命令！"
	exit 1;
fi

is64bit=$(getconf LONG_BIT)
if [ "${is64bit}" != '64' ];then
	Red_Error "抱歉, 当前面板版本不支持32位系统, 请使用64位系统或安装宝塔5.9!";
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
	echo "Ubuntu ${UbuntuCheck}不支持安装宝塔面板，建议更换Ubuntu18/20安装宝塔面板"
	exit 1
fi

#CentOS 7、Debian、Ubuntu
curl -sSL https://get.docker.com/ | sh
systemctl start docker
systemctl enable docker

docker run --restart always --name fast -p 89:8081 -d -v /var/run/docker.sock:/var/run/docker.sock wangbinxingkong/fast
	echo "http://服务器IP地址或域名:89 默认账号:admin 密码:888888"
