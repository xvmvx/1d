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


#ubuntu
yellow "${logo1}"
red "########################################"
blue "-----本机系统是：" ; green "${xitong%(Final)*}"
red "升级系统+更改时区+安装常用（git，wget等），go不go"
read -p "：" go1
if [[ "$go1" = "go" ]] then
    strA=${xitong}
    strB="ubuntu"
    strC="centos"
    result1=$(echo $strA | grep "${strB}")
    result2=$(echo $strA | grep "${strC}")
    if [[ "$result1" != "" ]] then
        sudo apt-get update && sudo apt-get upgrade
        sudo apt-get install git wget vim lsof unzip
        echo net.core.default_qdisc=fq >> /etc/sysctl.conf
        echo net.ipv4.tcp_congestion_control=bbr >> /etc/sysctl.conf
        sysctl -p
        sysctl net.ipv4.tcp_available_congestion_control
    elif  [[ "$result2" != "" ]] then
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
fi
red "修改SSH端口+修改root密码+添加用户，go不go"
read -p "：" go2
if [[ "$go2" = "go" ]] then
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
fi

red "alias+开启BBR+开启SWAG+测速管理，go不go"
read -p "：" go3
if [[ "$go3" = "go" ]] then
cat > ~/.bashrc <<EOF
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
 # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

 #if [ "$color_prompt" = yes ]; then
 #    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
 #else
 #    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
 #fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
PS1="\[\e[37;40m\][\[\e[30;42m\]\u\[\e[37;41m\]♚\h \[\e[37;44m\]\w\[\e[0m\]]\\$"
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'        
alias l.='ls -la'
alias ..='cd ..'
alias ...='cd ../..'
alias cd~='cd ~'
alias cc='cd /'
alias r='rm -rf'
alias dc='docker-compose up -d'
alias dv='vim docker-compose.yml'
b() { iptables -I INPUT -s "$1"; -j DROP;}
alias cdd='cd /docker; ls;'   # 进入并打开
c() { cd "$1"; ls;}   # 进入并打开
m() { mkdir -p "$1"; cd "$1";}  # 创建并进入
alias dps='docker ps'
alias dpsa='docker ps -a'
alias ds='docker stop'
alias dr='docker rm'
alias drn='docker network rm'
alias dn='docker network ls'
alias di='docker images'
alias dri='docker rmi'
alias v='vim'
alias a='alias'
alias f='find / -name'
alias ch='chmod +x'
alias salias='source ~/.bashrc'
alias valias='vim ~/.bashrc'
alias upda='sudo apt-get update && sudo apt-get upgrade'

alias nnn='nmon'
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi
alias mysql='docker exec -it  mysql bash'
de() { docker exec -it "$1" /bin/bash;}
alias psqlsu='su postgres'
psqlin(){ psql -U "$1" -W}
psqluser(){ CREATE USER "$1" WITH PASSWORD "$2";}
psqldb(){ CREATE DATABASE "$1" OWNER "$2";}

t() {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}
swap(){
wget -O "/root/swap.sh" "https://raw.githubusercontent.com/BlueSkyXN/ChangeSource/master/swap.sh" --no-check-certificate -T 30 -t 5 -d
chmod +x "/root/swap.sh"
chmod 777 "/root/swap.sh"
blue "下载完成"
blue "你也可以输入 bash /root/swap.sh 来手动运行"
bash "/root/swap.sh"
}
EOF
source ~/.bashrc
swag
fi

red "安装Docker+Docker-compose+dockerd面板+npm，go不go"
read -p "：" go4
if [[ "$go4" = "go" ]] then
yellow "安装Docker："
apt-get remove docker docker-engine docker.io containerd run 
sudo apt-get update && sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
docker version
    if [ $? != '0' ];then
      green "安装失败，人工检查！"
      exit 1
    fi
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version
    if [ $? != '0' ];then
      green "安装失败，人工检查！"
      exit 1
    fi
    if [ -d "/docker/" ];then
      if [ -d "/docker/npm" ];then
        rm -rf /docker/npm && mkdir /docker/npm
      else
        mkdir /docker/npm
      fi
    else
      mkdir /docker && mkdir /docker/npm
    fi
    cd /docker/npm
cat > docker-compose.yml <<EOF
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
EOF
    lsof -i:81 || apt install lsof  #安装lsof
    lsof -i:81 && docker-compose up -d
    if [ $? = '0' ];then
      green "npm安装成功  端口81 admin@example.com：changeme"
      green "IP参考"
      curl ifconfig.me
      ip addr show docker0
    fi
    if [ -d "/docker/portainer" ];then
        rm -rf /docker/portainer && mkdir /docker/portainer
    else
        mkdir /docker/portainer
    fi
    cd /docker/portainer
    wget https://labx.me/dl/4nat/public.zip && unzip public.zip
    lsof -i:82  && docker run -d --restart=always --name portainer -p 82:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data -v /docker/portainer/public:/public portainer/portainer:latest
     if [ $? = '0' ];then
      green "portainer安装成功  端口82 admin@example.com：changeme"
      green "IP参考"
      curl ifconfig.me
      ip addr show docker0
    fi
fi



# Wiki文档项目 Wikijs
cd /
mkdir docker && cd docker
mkdir npm && cd wikijs
cat > docker-compose.yml <<EOF
cp ${FILE1}/npm.yml docker-compose.yml
version: "2.1"
services:
  wikijs:
    image: lscr.io/linuxserver/wikijs
    container_name: wikijs
    environment:
      - PUID=1000        # 如何查看当前用户的PUID和PGID，直接命令行输入id就行
      - PGID=1000
      - TZ=Asia/Shanghai
    volumes:
      - /root/data/docker_data/wikijs/config:/config  # 配置文件映射到本地，数据不会因为Docker停止而丢失
      - /root/data/docker_data/wikijs/data:/data  # 数据映射到本地，数据不会因为Docker停止而丢失
    ports:
      - 91:3000   # 左边的8080可以自己调整端口号，右边的3000不要改
    restart: unless-stopped
EOF
docker-compose up -d
if [ $? = '0' ];then
  green "Wiki文档 安装成功  端口91"
fi

#个人知识库——Trilium

cd /
mkdir docker && cd docker
mkdir npm && cd wikijs
cat > docker-compose.yml <<EOF
cp ${FILE1}/npm.yml docker-compose.yml
version: '3'
services:
  trilium-cn:
    image: nriver/trilium-cn
    restart: always
    ports:
      - "92:8080"
    volumes:
      # 把同文件夹下的 trilium-data 目录映射到容器内
      - ./trilium-data:/root/trilium-data
    environment:
      # 环境变量表示容器内笔记数据的存储路径
      - TRILIUM_DATA_DIR=/root/trilium-data
EOF
docker-compose up -d
if [ $? = '0' ];then
  green "个人知识库-Trilium 安装成功  端口92"
  green "npm：Block。。force。。"
fi

# 同步工具——Syncthing

cd /
mkdir docker && cd docker
mkdir npm && cd syncthing
cat > docker-compose.yml <<EOF
cp ${FILE1}/npm.yml docker-compose.yml
version: "2.1"
services:
  syncthing:
    image: lscr.io/linuxserver/syncthing
    container_name: syncthing
    hostname: syncthing #optional
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai
    volumes:
      - /docker/syncthing/config:/config
      - /docker/syncthing/Documents:/Documents
      - /docker/syncthing/Media:/Media
    ports:
      - 93:8384
      - 22000:22000/tcp
      - 22000:22000/udp
      - 21027:21027/udp
    restart: unless-stopped
EOF
docker-compose up -d
if [ $? = '0' ];then
  green "同步工具——Syncthing 安装成功  端口93"
  green "npm：Block。websock....。force。http2...。"
fi

#简洁的记事本——minimalist-web-notepad

cd /
mkdir docker && cd docker
mkdir notepad && cd notepad
apt install unzip
sed -i "s|if (bind_user == 'True') {|if (bind_user == 'REMOVED') {|g" /www/server/panel/BTPanel/static/js/index.js
rm -rf /www/server/panel/data/bind.pl
wget https://github.com/pereorga/minimalist-web-notepad/archive/refs/heads/docker.zip

docker build -t minimalist-web-notepad .
docker run -d -it --restart=always --name minimalist-web-notepad -v /root/data/docker_data/minimalist/minimalist-data:/var/www/html/_tmp -p 94:80 minimalist-web-notepad
if [ $? = '0' ];then
  green "简洁的记事本——minimalist-web-notepad 安装成功  端口94  解压"
  green "npm：Block。websock....。force。http2...。"
fi




#为知笔记
cd /
mkdir docker && cd docker
mkdir wezhi && cd weizhi
docker run --name wiz --restart=always -it -d -v  ~/wizdata:/wiz/storage -v  /etc/localtime:/etc/localtime -p 98:80 -p 9269:9269/udp  wiznote/wizserver
if [ $? = '0' ];then
  green "为知笔记 安装成功  端口98"
fi




#网站流量监控——Umami
cd /
mkdir docker && cd docker
mkdir npm && cd umami
green "需要使用docker、curl、git、vim、wget等必备的工具"

cat > docker-compose.yml <<EOF
cp ${FILE1}/npm.yml docker-compose.yml
version: '3'
services:
  umami:
    image: ghcr.io/umami-software/umami:postgresql-latest
    ports:
      - "82:3000"
    environment:
      DATABASE_URL: postgresql://umami:umami@db:5432/umami # 这里的数据库和密码要和下方你修改的相同
      DATABASE_TYPE: postgresql
      HASH_SALT: replace-me-with-a-random-string
    depends_on:
      - db
    restart: always
  db:
    image: postgres:12-alpine
    environment:
      POSTGRES_DB: umami
      POSTGRES_USER: umami # 数据库用户
      POSTGRES_PASSWORD: umami  # 数据库密码
    volumes:
      - ./sql/schema.postgresql.sql:/docker-entrypoint-initdb.d/schema.postgresql.sql:ro
      - ./umami-db-data:/var/lib/postgresql/data
    restart: always
EOF
docker-compose up -d
if [ $? = '0' ];then
  green "网站流量监控——Umami 安装成功  端口82"
  green "npm： force。。"
fi


#网站监控——Uptime Kuma
cd /
mkdir docker && cd docker
mkdir npm && cd kuma
green "需要使用docker、curl、git、vim、wget等必备的工具"

cat > docker-compose.yml <<EOF
cp ${FILE1}/npm.yml docker-compose.yml
version: '3.3'

services:
  uptime-kuma:
    image: louislam/uptime-kuma
    container_name: uptime-kuma
    volumes:
      - ./uptime-kuma:/app/data
    ports:
      - 3001:3001

EOF
docker-compose up -d
if [ $? = '0' ];then
  green "网站监控——Uptime Kuma 安装成功  端口82"
  green "npm： force。。"
fi


# Ubuntu的桌面系统
cd /
mkdir docker && cd docker
mkdir npm && cd vnc
green "需要使用docker、curl、git、vim、wget等必备的工具"

cat > docker-compose.yml <<EOF
version: '3.5'

services:
    ubuntu-xfce-vnc:
        container_name: xfce
        image: imlala/ubuntu-xfce-vnc-novnc:latest
        shm_size: "1gb"  # 防止高分辨率下Chromium崩溃,如果内存足够也可以加大一点点
        ports:
            - 83:5900   # TigerVNC的服务端口（保证端口是没被占用的，冒号右边的端口不能改，左边的可以改）
            - 84:6080   # noVNC的服务端口，注意事项同上
        environment: 

            - VNC_PASSWD=Guwei888   # 改成你自己想要的密码
            - GEOMETRY=1280x720      # 屏幕分辨率，800×600/1024×768诸如此类的可自己调整
            - DEPTH=24               # 颜色位数16/24/32可用，越高画面越细腻，但网络不好的也会更卡
        volumes: 
            - ./Downloads:/root/Downloads  # Chromium/Deluge/qBittorrent/Transmission下载的文件默认保存位置都是root/Downloads下
            - ./Documents:/root/Documents  # 映射一些其他目录
            - ./Pictures:/root/Pictures
            - ./Videos:/root/Videos
            - ./Music:/root/Music
        restart: unless-stopped

EOF
docker-compose up -d
if [ $? = '0' ];then
  green "Ubuntu的桌面系统 安装成功  vnc端口83 novnc端口84  密码Guwei888"
  green "npm：Block。websock....。force。http2...。"
  green "类似项目参考：docker run -itd --restart=always -p 6080:80 -e HTTP_PASSWORD=mypassword -v /root/data/docker_data/Ubuntu_desktop/dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc"
  
fi


#Guacamole远程桌面网关服务
cd /
mkdir docker && cd docker
mkdir vnc && cd vnc
green "需要使用docker、curl、git、vim、wget等必备的工具"

cat > docker-compose.yml <<EOF
version: "3"
services:
  guacamole:
    image: jwetzell/guacamole
    container_name: guacamole
    volumes:
      - ./postgres:/config
    ports:
      - 85:8080
volumes:
  postgres:
    driver: local
EOF
docker-compose up -d
if [ $? = '0' ];then
  green "Ubuntu的桌面系统 安装成功  端口85 帐号密码guacadmin"
  green "npm：Block。websock....。force。http2...。"
  green "类似项目参考：docker run -itd --restart=always -p 6080:80 -e HTTP_PASSWORD=mypassword -v /root/data/docker_data/Ubuntu_desktop/dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc"
  
fi

# 服务器监控——Ward && ServerStatus
cd /
mkdir docker && cd docker
git clone https://github.com/AntonyLeons/Ward.git   ## 在创建的文件夹下克隆项目并构建镜像
cd Ward 
docker build . --tag ward
docker run -d --name ward -p 86:4000 \
-p 87:87 \
--privileged=true \
--restart always \
ward:latest


if [ $? = '0' ];then
  green "Ubuntu的桌面系统 安装成功  端口86  87"
  green "太复杂。。。"
  green "https://blog.laoda.de/archives/ward-serverstatus-install"  
fi

#可视化面板——Portainer
cd /
mkdir docker && cd docker
mkdir portainer && cd portainer
docker run -d -p 100:8000 -p 99:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data portainer/portainer-ce:latest
red "选用Docker-compose（1）？或用Docker（2）？"
read -p "输入你的选择：" Dpor
if [ "$Dpor"= '1' ];then
cat > docker-compose.yml <<EOF
version: "2"
services:
  qbittorrent:
    image: linuxserver/qbittorrent
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Asia/Shanghai # 你的时区
      - UMASK_SET=022
      - WEBUI_PORT=101 # 将此处修改成你欲使用的 WEB 管理平台端口 
    volumes:
      - /docker/qbittorrent/qBittorrent/config:/config # 绝对路径请修改为自己的config文件夹
      - /docker/qbittorrent/qBittorrent/downloads:/downloads # 绝对路径请修改为自己的downloads文件夹
    ports:
      # 要使用的映射下载端口与内部下载端口，可保持默认，安装完成后在管理页面仍然可以改成其他端口。
      - 6881:6881 
      - 6881:6881/udp
      # 此处WEB UI 目标端口与内部端口务必保证相同，见问题1
      - 101:8081
    restart: unless-stopped
EOF
docker-compose up -d
  if [ $? = '0' ];then
    green "可视化面板——Portainer  安装成功  端口99 100  101"
    green "?>?? "
  else
      echo 安装失败，人工检查！
  fi
elif [ "$Dpor"= '2' ];then
docker run -d \
    -v /root/data/docker_data/qbittorrent/qBittorrent/downloads:/srv \
    -p 102:80 \
    --name filebrowser \
    langren1353/filebrowser-ckplayer
  if [ $? = '0' ];then
    green "可视化面板——Portainer  安装成功  端口102"
    green "?>?? "
  else
      echo 安装失败，人工检查！
  fi
fi



#网盘直链程序——AList

cd /
mkdir docker && cd docker
mkdir npm && cd alist
red "选用一键安装脚本（1）？或用Docker（2）？"
read -p "输入你的选择：" AList
if [ "$AList"= '1' ];then
curl -fsSL "https://nn.ci/alist.sh" | bash -s install /root   # 安装
  if [ $? = '0' ];then
    green "网盘直链程序——AList 安装成功"
    alistgeng=${curl -fsSL "https://nn.ci/alist.sh" | bash -s update /root   # 更新}
    alistgxie=${curl -fsSL "https://nn.ci/alist.sh" | bash -s uninstall /root   # 卸载}
    green "更新:"; echo ${alistgeng}
    green "卸载:"; echo ${alistgxie}
  else
    echo 安装失败，人工检查！
  fi
elif [ "$AList" = "2" ]; then
docker logs alist || docker exec -it alist ./alist -password
red "安装稳定版本（1）？或者安装开发者版本（2）？"
read -p "输入你的选择：" AListban
  if [ "$AListban"= '1' ];then
    docker run -d --restart=always -v /docker/alist:/opt/alist/data -p 71:5244 --name="alist" xhofe/alist:latest
  elif [ "$AListban"= '2' ];then
    docker run -d --restart=always -v /docker/alist:/opt/alist/data -p 71:5244 --name="alist" xhofe/alist:v2
  fi
fi
if [ $? = '0' ];then
  green "网盘直链程序——AList  安装成功  端口71"
  green "https://blog.laoda.de/archives/docker-install-alist"
else
    echo 安装失败，人工检查！
fi




#个人网盘——FileRun
cd /
mkdir docker && cd docker
mkdir npm && cd filerun
green "需要使用docker、curl、git、vim、wget等必备的工具"

cat > docker-compose.yml <<EOF
cp ${FILE1}/npm.yml docker-compose.yml
version: '2'

services:
  db:    # 数据库服务
    image: mariadb:10.1
    environment:
      MYSQL_ROOT_PASSWORD: Guwei888  # 数据库root用户的密码，自行修改
      MYSQL_USER: goodway   # 数据库用户名，自行修改
      MYSQL_PASSWORD: Guwei888 # 数据库密码，自行修改
      MYSQL_DATABASE: goodway #数据库名，自行修改
    volumes:
      - /docker/filerun/db:/var/lib/mysql  # 挂载路径，冒号左边可以自己修改成VPS本地的路径，冒号右边为Docker容器内部路径，不能修改
    restart: always

  web:  # 网页服务
    image: filerun/filerun
    environment:
      FR_DB_HOST: db
      FR_DB_PORT: 3306
      FR_DB_NAME: goodway
      FR_DB_USER: goodway
      FR_DB_PASS: Guwei888
      APACHE_RUN_USER: www-data
      APACHE_RUN_USER_ID: 33
      APACHE_RUN_GROUP: www-data
      APACHE_RUN_GROUP_ID: 33
    depends_on:
      - db
    links:
      - db:db  # 两个容器互相连接
    ports:
      - "72:80"  # Docker内部的80端口映射到VPS本地的8000端口，8000端口记得防火墙打开（宝塔、阿里云、腾讯云）
    volumes:
      - /docker/filerun/html:/var/www/html  # 挂载路径，冒号左边可以自己修改成VPS本地的路径，冒号右边为Docker容器内部路径，不能修改
      - /docker/filerun/user-files:/user-files  # 挂载路径，冒号左边可以自己修改成VPS本地的路径，冒号右边为Docker容器内部路径，不能修改
EOF
docker-compose up -d
if [ $? = '0' ];then
  green "个人网盘——FileRun 安装成功  端口82"
  green "npm：Block。。 force。。"
fi












# 工具
apt update -y
apt install -y wget vim sudo curl git
wget -qO- get.docker.com | bash
docker -v
systemctl enable docker
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
