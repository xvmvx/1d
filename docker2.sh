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
red "############  Docker  #################"
blue "基础安装"
yellow "          NPM 安装（1）"
yellow "          Portainer 安装（2）"
blue "面板/文档/记事本"
yellow "          安装Wiki文档项目（3）"
yellow "          个人知识库——Trilium（4）"
yellow "          同步工具——Syncthing（5）"
yellow "          简洁的记事本（6）"
yellow "          个为之笔记（7）"
blue "面板/监控/网盘"
yellow "          网站流量监控——Umami（8）"
yellow "          网盘直链程序——AList（9）"
yellow "          网站流量监控——Umami（10）"
yellow "          个人网盘——FileRun（11）"
yellow "          可视化面板——Portainer（12）"
yellow "          服务器监控——Ward && ServerStatus（13）"
yellow "          Guacamole远程桌面网关服务（14）"
yellow "          Ubuntu的桌面系统（15）"
yellow "          网站监控——Uptime Kuma（16）"

red "录入正确的编号开始安装"
read -p "："  ddd
if [[ "$ddd" = "1" ]]; then
yellow "安装Docker："
