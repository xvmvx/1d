#!/bin/bash
myFILE="wikijs"  
myPORT="721"
sudo apt update -y  # 升级packages
sudo apt install wget curl sudo vim git  # Debian系统比较干净，安装常用的软件
mkdir -p /docker/wikijs && cd /docker/wikijs
cat >docker-compose.yml<< EOF
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
      - 72:3000   # 左边的8080可以自己调整端口号，右边的3000不要改
    restart: unless-stopped
EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    green "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    yello "其他注意事项⚠️⚠️⚠️：npm:ca.block.web+for"
    green "IP参考https://blog.laoda.de/archives/docker-compose-install-wikijs"
    curl ifconfig.me
    ip addr show docker0
    read -p "继续安装面板（y）："  pro
        if [[ "$pro" = "y" ]]; then
            pro
        fi
    elif [ $? != '0' ]; then
        red "安装失败，人工检查！"
        exit 1
    fi

