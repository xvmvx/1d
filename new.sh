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
MY=${release}
myIP1=$(curl ip.sb)
myIP2=$(ip route get 1 | awk '{print $7;exit}')
yellow "${logo1}"
red "########################################"
if [[ ${MY} == "debian" ]]; then
  sudo apt-get update && sudo apt-get upgrade
  sudo apt-get install git wget vim lsof unzip
elif [[ ${MY} == "ubuntu" ]]; then
  sudo apt-get update && sudo apt-get upgrade
  sudo apt-get install git wget vim lsof unzip
elif [[ ${MY} == "centos" ]]; then
  sudo yum update && sudo yum upgrade
  yum install wget git vim
fi
sudo timedatectl set-timezone Asia/Shanghai #改成上海
read -p "修改SSH端口号（y），确认修改：       " changeSSH
if [[ "$changeSSH" = "y" ]] ; then
  source ssh22.sh
fi
blue -e "请选择要安装的面板："
yellow "1. 宝塔面板"
yellow "2. AMH面板"
yellow "3. DOCKER"
yellow "4. NPM面板"
read -e -p "(输入为空则取消):" inMY
  if [[ ${inMY} == "1" ]]; then
    echo -e "宝塔面板>>>要执行的操作："
 	  echo "1. 全新安装"
    echo "2. 升级代码"
    echo "3. 还原到官方最新版"
    read -e -p "(输入为空则取消):" inBT
      if [[ ${inBT} == "1" ]]; then
        if [[ ${MY} == "debian" ]]; then
          # Debian全新安装命令：
          wget -O install.sh http://v7.hostcli.com/install/install-ubuntu_6.0.sh && bash install.sh
        elif [[ ${MY} == "ubuntu" ]]; then
          # ubuntu/Deepin全新安装命令：
          wget -O install.sh http://v7.hostcli.com/install/install-ubuntu_6.0.sh && sudo bash install.sh
        elif [[ ${MY} == "centos" ]]; then
          # Centos全新安装命令：根据系统执行框内命令开始安装（大约2分钟完成面板安装）升级后可能需要重启面板
          yum install -y wget && wget -O install.sh http://v7.hostcli.com/install/install_6.0.sh && sh install.sh
        else
          # Fedora全新安装命令：
          wget -O install.sh http://v7.hostcli.com/install/install_6.0.sh && bash install.sh
        fi
       elif [[ ${inBT} == "2" ]]; then
          # 升级代码/修复面板：已经安装官方面板，执行下列命令升级到7.6.0纯净版：
          curl http://v7.hostcli.com/install/update6.sh|bash
          # 其他非官方版本含开心版、快乐版、纯净版等 7.4.5至7.6.0版本之间所有版本均可，执行下列命令升级到7.6.0纯净版：
          curl http://v7.hostcli.com/install/update6.sh|bash
       elif [[ ${inBT} == "3" ]]; then
          # 任意非官方版本还原到官方最新版：
          curl http://download.bt.cn/install/update6.sh|bash
       fi
     elif [[ ${inMY} == "2" ]]; then
       # amh面板
       wget http://dl.amh.sh/amh.sh && bash amh.sh
     elif [[ ${inMY} == "3" ]]; then
       # Docker
       source 13.sh
     fi
     
