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
mv  ~/.bashrc  ~/.bashrc1
cp my.bashrc ~/.bashrc
source ~/.bashrc
#ubuntu
yellow "${logo1}"
red "########################################"
blue "-----本机系统是：" ; green "$name"
red "升级系统+更改时区+安装常用（git，wget等），go不go(1)"
red "修改SSH端口(⚠️⚠️⚠️）+修改root密码+添加用户，go不go(2)"
red "alias+开启BBR+开启SWAG+测速管理，go不go（3）"
red "安装Docker+Docker-compose+dockerd面板+npm，go不go（4）"
red "安装 ，go不go（5）"
echo -n "输入你的选择 > "
read character
if [ "$character" = "1" ]; then
    source 11.sh || ./11.sh
elif [ "$character" = "2" ]; then
    source 12.sh || ./12.sh
elif [ "$character" = "3" ]; then
     source 13.sh || ./13.sh
elif [ "$character" = "4" ]; then
     source 14.sh || ./14.sh
elif [ "$character" = "5" ]; then
     source 15.sh || ./15.sh
else
    echo 输入不符合要求
fi
