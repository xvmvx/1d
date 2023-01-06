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
	exit 1
fi 

UbuntuCheck=$(cat /etc/issue|grep Ubuntu|awk '{print $2}'|cut -f 1 -d '.')
if [ "${UbuntuCheck}" ] && [ "${UbuntuCheck}" -lt "16" ];then
	echo "Ubuntu ${UbuntuCheck}不支持安装，建议更换Ubuntu18/20安装"
	exit 1
fi

#CentOS 7、Debian、Ubuntu
docker pull nextcloud
docker run -d --restart=always --name nextcloud -p 82:80 nextcloud
echo "http://服务器IP地址或域名:82 面板添加账号，苹果浏览器支持不好"
