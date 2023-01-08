#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
LANG=en_US.UTF-8
if [ $(whoami) != "root" ]; then
	echo "请使用root权限执行！"
	exit 1;
fi

is64bit=$(getconf LONG_BIT)
if [ "${is64bit}" != '64' ]; then
	Red_Error "抱歉, 不支持32位系统, 请使用64位系统!";
fi

Centos6Check=$(cat /etc/redhat-release | grep ' 6.' | grep -iE 'centos|Red Hat')
if [ "${Centos6Check}" ]; then
	yum update -y

  #清除旧的docker
  yum remove docker \
      docker-client \
      docker-client-latest \
      docker-common \
      docker-latest \
      docker-latest-logrotate \
      docker-logrotate \
      docker-selinux \
      docker-engine-selinux \
      docker-engine

    #安装docker依赖
    yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2

    #添加docker官方源
    yum-config-manager \
        --add-repo \
        https://download.docker.com/linux/centos/docker-ce.repo

    #安装最新版docker
    yum install docker-ce -y

    #使用阿里加速镜像
    #sudo mkdir -p /etc/docker
    #sudo tee /etc/docker/daemon.json <<-'EOF'
    #{
    #  "registry-mirrors": ["https://自己去阿里云申请,免费的"]
    #}
    #EOF

    sudo systemctl daemon-reload
    sudo systemctl restart docker
    sudo systemctl enable docker
    echo "如果service firewalld status查看防火墙打开的话,建议关闭"
    echo "systemctl stop firewalld"
    echo "systemctl disable firewalld"
    echo "如果yum install docker-ce -y报错"
    echo "Problem: package docker-ce-3:19.03.3-3.el7.x86_64 requires containerd.io >= 1.2.2-3, but none of the providers can be installed"
    echo "则需要运行下面安装containerd.io-1.2.6"
    echo "yum install -y https://download.docker.com/linux/centos/7/x86_64/edge/Packages/containerd.io-1.2.6-3.3.el7.x86_64.rpm"
#推荐安装portainer管理docker
#CentOS 6
	exit 1
fi 

UbuntuCheck=$(cat /etc/issue|grep Ubuntu|awk '{print $2}'|cut -f 1 -d '.')
if [ "${UbuntuCheck}" ] && [ "${UbuntuCheck}" -lt "16" ]; then
    #清除旧的docker
    sudo apt-get remove docker docker-engine docker.io

    #安装docker依赖
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common

    #添加密码指纹
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88

    #添加仓库
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    #根据官方指导刷新软件库会报错没有公钥，以下操作网上查到的
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F76221572C52609D
    sudo apt-get clean

    #再次刷新软件库
    sudo apt-get update

    #安装最新版docker
    sudo apt-get -y install docker-ce

    #使用阿里加速镜像
    #sudo mkdir -p /etc/docker
    #sudo tee /etc/docker/daemon.json <<-'EOF'
    #{
    #  "registry-mirrors": ["https://自己去阿里云申请,免费的"]
    #}
    #EOF

#推荐安装portainer管理docker

	exit 1
fi
sudo apt update
sudo apt install apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker
