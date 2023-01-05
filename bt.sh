#!/bin/bash
yum install -y wget && wget -O install.sh https://bt.vpnkol.com/install/install_6.0.sh && sh install.sh
if [ $? = '0' ]; then
  echo "安装完成✅✅✅！安装更新......"
else
  wget -O install.sh https://bt.vpnkol.com/install/install_6.0.sh && bash install.sh
if
curl https://bt.vpnkol.com/install/update6.sh|bash
echo "安装完成✅✅✅！
