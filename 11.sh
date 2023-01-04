#!/bin/bash
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}


logo="$(tput setaf 6)
   ____                 ___        __
  / ___| ___   ___   __| \ \      / /_ _ _   _ 
 | |  _ / _ \ / _ \ / _` |\ \ /\ / / _` | | | |
 | |_| | (_) | (_) | (_| | \ V  V / (_| | |_| |
  \____|\___/ \___/ \__,_|  \_/\_/ \__,_|\__, |
                                         |___/ 
$(tput sgr0)"

logo1="$(tput setaf 6)
    ▄▄▄▄                             ▄▄ ▄▄      ▄▄                    
  ██▀▀▀▀█                            ██ ██      ██                    
 ██         ▄████▄    ▄████▄    ▄███▄██ ▀█▄ ██ ▄█▀  ▄█████▄  ▀██  ███ 
 ██  ▄▄▄▄  ██▀  ▀██  ██▀  ▀██  ██▀  ▀██  ██ ██ ██   ▀ ▄▄▄██   ██▄ ██  
 ██  ▀▀██  ██    ██  ██    ██  ██    ██  ███▀▀███  ▄██▀▀▀██    ████▀  
  ██▄▄▄██  ▀██▄▄██▀  ▀██▄▄██▀  ▀██▄▄███  ███  ███  ██▄▄▄███     ███   
    ▀▀▀▀     ▀▀▀▀      ▀▀▀▀      ▀▀▀ ▀▀  ▀▀▀  ▀▀▀   ▀▀▀▀ ▀▀     ██    
                                                              ███     
$(tput sgr0)"

xitong=$(cat /etc/issue)
IP1=$(curl ip.sb)
IP2=$(ip route get 1 | awk '{print $7;exit}')
FILE1=${pwd}

clear
if [ ${name} = "Ubuntu" ] then

  sudo apt-get update && sudo apt-get upgrade
  sudo apt-get install git wget vim lsof unzip
  echo net.core.default_qdisc=fq >> /etc/sysctl.conf
  echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
  sysctl -p
  sysctl net.ipv4.tcp_available_congestion_control
elif  [[ "$anme" = "CentOS" ]] then
  sudo yum update && sudo yum upgrade
  yum install wget git vim
  wget -N --no-check-certificate "https://raw.githubusercontent.com/chiakge/Linux-NetSpeed/master/tcp.sh"
  chmod +x tcp.sh
  ./tcp.sh
fi
blue "更新🆕🆕🆕.........."
sudo timedatectl set-timezone Asia/Shanghai #改成上海
if [ $? = '0' ];then
  blue "-----本机时区是：" ; green "Asia/Shanghai #改成上海"
fi
red "升级系统+更改时区+安装常用（git，wget等）完成，继续修改SSH端口+修改root密码+添加用户（1）"
read -p "返回上层（0），其他退出：" go1
if [[ "$go1" = "1" ]] then
    read -p "输入要修改的端口号(默认29992）：" portNum
    each "Port 22">>/etc/ssh/sshd_config
    if [ ${portNum} != '0' ];then
      each -n "Port "; ${portNum} >>/etc/ssh/sshd_config
    fi
    each -n "Port 29992">>/etc/ssh/sshd_config  
    sudo service sshd restart
    red "新的端口已经生效,新开窗口测试登陆！！！ "
    red "新的端口已经生效,新开窗口测试登陆！！！ "
    red "新的端口已经生效,新开窗口测试登陆！！！ "
    yellow "修改密码："
    passwd
    yellow "新建用户："
    adduser
elif [[ "$go1" = "0" ]] then
seacuse 1.sh
fi
