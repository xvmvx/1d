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
red "############  Wiki  #################"
yellow " 网站流量监控——Umami"
yellow "网站监控——Uptime Kuma"
yellow "Ubuntu的桌面系统"
yellow "Guacamole远程桌面网关服务"
yellow "服务器监控——Ward && ServerStatus"
red "安装Wiki文档项目(1),个人知识库——Trilium(2),同步工具——Syncthing(3),简洁的记事本94),为之笔记（5）"
read -p "："  mian
if [[ "$mian" = "1" ]] then
# 网站流量监控——Umami
myFILE="umami"  
myPORT="71"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
version: '3'
services:
  umami:
    image: ghcr.io/umami-software/umami:postgresql-latest
    ports:
      - "71:3000"
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
lsof -i:${myPORT} && docker-compose up -d
if [ $? = '0' ]; then
  green "${myFILE} 安装成功  端口:${myPORT}"
  yellow "其他注意事项⚠️⚠️⚠️：  npm： force。。"
  green "IP参考"
  curl ifconfig.me
  ip addr show docker0
fi

# 网站监控——Uptime Kuma
elif [[ "$mian" = "2" ]] then
myFILE="kuma"  
myPORT="72"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
version: '3.3'
services:
  uptime-kuma:
    image: louislam/uptime-kuma
    container_name: uptime-kuma
    volumes:
      - ./uptime-kuma:/app/data
    ports:
      - 72:3001
EOF
lsof -i:${myPORT} && docker-compose up -d
if [ $? = '0' ]; then
  green "${myFILE} 安装成功  端口:${myPORT}"
  yellow "其他注意事项⚠️⚠️⚠️：  npm： force。。"
  green "IP参考"
  curl ifconfig.me
  ip addr show docker0
fi

# Ubuntu的桌面系统
elif [[ "$mian" = "3" ]] then
myFILE="xfce"  
myPORT="73"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
version: '3.5'
services:
    ubuntu-xfce-vnc:
        container_name: xfce
        image: imlala/ubuntu-xfce-vnc-novnc:latest
        shm_size: "1gb"  # 防止高分辨率下Chromium崩溃,如果内存足够也可以加大一点点
        ports:
            - 73:5900   # TigerVNC的服务端口（保证端口是没被占用的，冒号右边的端口不能改，左边的可以改）
            - 74:6080   # noVNC的服务端口，注意事项同上
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
lsof -i:${myPORT} && docker-compose up -d
if [ $? = '0' ]; then
  green "${myFILE} 安装成功  端口:${myPORT}"
  yellow "其他注意事项⚠️⚠️⚠️：  npm： force。。"
  green "IP参考"
  curl ifconfig.me
  ip addr show docker0
  green "Ubuntu的桌面系统 安装成功  vnc端口83 novnc端口84  密码Guwei888"
  green "npm：Block。websock....。force。http2...。"
  green "类似项目参考：docker run -itd --restart=always -p 6080:80 -e HTTP_PASSWORD=mypassword -v /root/data/docker_data/Ubuntu_desktop/dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc"
fi


#Guacamole远程桌面网关服务
elif [[ "$mian" = "4" ]] then
myFILE="guacamole"  
myPORT="75"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
version: "3"
services:
  guacamole:
    image: jwetzell/guacamole
    container_name: guacamole
    volumes:
      - ./postgres:/config
    ports:
      - 75:8080
volumes:
  postgres:
    driver: local
EOF
lsof -i:${myPORT} && docker-compose up -d
if [ $? = '0' ]; then
  green "${myFILE} 安装成功  端口:${myPORT}"
  yellow "其他注意事项⚠️⚠️⚠️：  npm：Block。websock....。force。http2...。"
  green "Ubuntu的桌面系统 安装成功  端口85 帐号密码guacadmin"
  green "npm：Block。websock....。force。http2...。"
  green "类似项目参考：docker run -itd --restart=always -p 6080:80 -e HTTP_PASSWORD=mypassword -v /root/data/docker_data/Ubuntu_desktop/dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc"
fi

# 服务器监控——Ward && ServerStatus
elif [[ "$mian" = "5" ]] then
myFILE="ward"  
myPORT="76"
cd /docker
git clone https://github.com/AntonyLeons/Ward.git   ## 在创建的文件夹下克隆项目并构建镜像
cd Ward 
docker build . --tag ward
docker run -d --name ward -p 76:4000 \
-p 77:87 \
--privileged=true \
--restart always \
ward:latest


if [ $? = '0' ];then
  green "Ubuntu的桌面系统 安装成功  端口76 77"
  green "太复杂。。。"
  green "https://blog.laoda.de/archives/ward-serverstatus-install"  
fi
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




