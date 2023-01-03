#!/bin/bash

np1="\[" #不可打印字符开始
np2="\]" #不可打印字符结束

c0="$np1""\e[0m""$np2" #默认颜色
c1="$np1""\e[0;92m""$np2" #绿
c2="$np1""\e[1;93m""$np2" #黄 加粗
c3="$np1""\e[0;91m""$np2" #红
c4="$np1""\e[0;93m""$np2" #黄

h1="$$ 💖\u❢\h❣" # PID-用户名@机器名:
h2="\w "  # pwd
h3="𐩔   "  # $

if [[ $TERM =~ "xterm" ||  $TERM =~ "rxvt" ]]; then
    # 平时不执行命令时的标题
    t1="\e]0;"
    t2="\w" # pwd
    t3="   终端  $TERM"    # 终端类型
    t4="\a"
fi

PS1="${np1}${t1}${t2}${t3}${t4}${np2}\$(LEC=\$? ; if [[ \$LEC -ne 0 ]]; then  echo -n '\[\e[0;91m\]' ; fi ; printf \"(%3d)\" \$LEC) ${c1}${h1}${c2}${h2}${c3}${h3}${c0}"

if [[ $TERM =~ "xterm" ||  $TERM =~ "rxvt" ]]; then
    trap 'echo -ne "\033]0;" ; echo -n "${BASH_COMMAND}" ; echo -ne "  正在执行\007" > /dev/stderr' DEBUG
fi
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
0(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
