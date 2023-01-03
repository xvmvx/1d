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



IP=`ifconfig | grep inet | grep -vE 'inet6|127.0.0.1' | awk '{print $2}'`   # 本地IP地址
cpu_num=`grep -c "model name" /proc/cpuinfo`  # 获取cpu总核数
cpu_user=`top -b -n 1 | grep Cpu | awk '{print $2}' | cut -f 1 -d "%"`  # 1、获取CPU利用率
cpu_system=`top -b -n 1 | grep Cpu | awk '{print $4}' | cut -f 1 -d "%"`  # 获取内核空间占用CPU百分比
cpu_free=`top -b -n 1 | grep Cpu | awk '{print $8}' | cut -f 1 -d "%"`  # 获取空闲CPU百分比
cpu_wait=`top -b -n 1 | grep Cpu | awk '{print $10}' | cut -f 1 -d "%"`  # 获取等待输入输出占CPU百分比
cpu_rupt=`vmstat -n 1 1 | sed -n 3p | awk '{print $11}'`  # 获取CPU中断次数
cpu_context=`vmstat -n 1 1 | sed -n 3p | awk '{print $12}'`  # 获取CPU上下文切换次数
cpu_15=`uptime | awk '{print $11}' | cut -f 1 -d ','`  # 获取CPU15分钟前到现在的负载平均值
cpu_5=`uptime | awk '{print $10}' | cut -f 1 -d ','`  # 获取CPU5分钟前到现在的负载平均值
cpu_1=`uptime | awk '{print $9}' | cut -f 1 -d ','`  # 获取CPU1分钟前到现在的负载平均值
cpu_length=`vmstat -n 1 1 | sed -n 3p | awk '{print $1}'`  # 获取任务队列(就绪状态等待的进程数) 
mem_total=`free | grep Mem | awk '{print $2}'`  # 获取物理内存总量
mem_used=`free | grep Mem | awk '{print $3}'`  # 获取操作系统已使用内存总量
mem_free=`free | grep Mem | awk '{print $4}'`  # 获取操作系统未使用内存总量 
mem_uused=`free | sed -n 3p | awk '{print $3}'`  # 获取应用程序已使用的内存总量
mem_user_free=`free | sed -n 3p | awk '{print $4}'`  # 获取应用程序未使用内存总量
mem_swap=`free | grep Swap | awk '{print $2}'`  # 获取交换分区总大小 
mem_swap_used=`free | grep Swap | awk '{print $3}'`  # 获取已使用交换分区大小
mem_swap_free=`free | grep Swap | awk '{print $4}'`  # 获取剩余交换分区大小
disk_sda_rs=`iostat -kx | grep sda| awk '{print $4}'` # 每秒向设备发起的读请求次数
disk_sda_ws=`iostat -kx | grep sda| awk '{print $5}'`  # 每秒向设备发起的写请求次数
disk_sda_avgqu_sz=`iostat -kx | grep sda| awk '{print $9}'`  # 向设备发起的I/O请求队列长度平均值
disk_sda_await=`iostat -kx | grep sda| awk '{print $10}'`  # 每次向设备发起的I/O请求平均时间
disk_sda_svctm=`iostat -kx | grep sda| awk '{print $11}'`  # 向设备发起的I/O服务时间均值
disk_sda_util=`iostat -kx | grep sda| awk '{print $12}'`  # 向设备发起I/O请求的CPU时间百分占比



echo "cpu总核数："$cpu_num
echo "IP地址："$IP
echo "用户空间占用CPU百分比："$cpu_user
echo "内核空间占用CPU百分比："$cpu_system
echo "空闲CPU百分比："$cpu_free
echo "等待输入输出占CPU百分比："$cpu_wait
echo "CPU中断次数："$cpu_rupt
echo "CPU上下文切换次数："$cpu_context
echo "CPU 15分钟前到现在的负载平均值："$cpu_15
echo "CPU 5分钟前到现在的负载平均值："$cpu_5
echo "CPU 1分钟前到现在的负载平均值："$cpu_1
echo "CPU任务队列长度："$cpu_task_length
echo "物理内存总量："$mem_total
echo "已使用内存总量(操作系统)："$mem_used
echo "剩余内存总量(操作系统)："$mem_free
echo "已使用内存总量(应用程序)："$mem_uused
echo "剩余内存总量(应用程序)："$mem_user_free
echo "交换分区总大小："$mem_swap
echo "已使用交换分区大小："$mem_swap_used
echo "剩余交换分区大小："$mem_swap_free
echo "指定设备(/dev/sda)的统计信息"
echo "每秒向设备发起的读请求次数："$disk_sda_rs
echo "每秒向设备发起的写请求次数："$disk_sda_ws
echo "向设备发起的I/O请求队列长度平均值"$disk_sda_avgqu_sz
echo "每次向设备发起的I/O请求平均时间："$disk_sda_await
echo "向设备发起的I/O服务时间均值："$disk_sda_svctm
echo "向设备发起I/O请求的CPU时间百分占比："$disk_sda_util





cat ip.txt
112.456.44.55
192.168.12.43
256.18.56.1
25.34.345.7
25.34.83.645
10.0.0.1
 
egrep '(^([1-9]|1[0-9]|1[1-9]{2}|2[0-4][0-9]|25[0-5])\.)(([0-9]{1,2}|1[1-9]{2}|2[0-4][0-9]|25[0-5])\.){2}([0-9]{1,2}|1[1-9]{2}|2[0-5][0-9]|25[0-4])$' ip.txt
