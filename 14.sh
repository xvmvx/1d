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
yellow " Wiki文档项目"
yellow "个人知识库——Trilium"
yellow "同步工具——Syncthing"
red "安装Wiki文档项目(1),个人知识库——Trilium(2),同步工具——Syncthing(3)"
read -p "："  wiki
if [[ "$wiki" = "1" ]] then
# Wiki文档项目 Wikijs
myFILE="Wikijs"  
myPORT="61"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
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
      - /docker/wikijs/config:/config  # 配置文件映射到本地，数据不会因为Docker停止而丢失
      - /docker/wikijs/data:/data  # 数据映射到本地，数据不会因为Docker停止而丢失
    ports:
      - 61:3000   # 左边的8080可以自己调整端口号，右边的3000不要改
    restart: unless-stopped
EOF
lsof -i:${myPORT} && docker-compose up -d
if [ $? = '0' ]; then
  green "${myFILE} 安装成功  端口:${myPORT}"
  yellow "其他注意事项⚠️⚠️⚠️： admin@example.com：changeme"
  green "IP参考"
  curl ifconfig.me
  ip addr show docker0
fi



elif [[ "$wiki" = "2" ]] then
# 个人知识库——Trilium
myFILE="trilium"  
myPORT="62"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
version: '3'
services:
  trilium-cn:
    image: nriver/trilium-cn
    restart: always
    ports:
      - "62:8080"
    volumes:
      # 把同文件夹下的 trilium-data 目录映射到容器内
      - ./trilium-data:/root/trilium-data
    environment:
      # 环境变量表示容器内笔记数据的存储路径
      - TRILIUM_DATA_DIR=/root/trilium-data
EOF
lsof -i:${myPORT} && docker-compose up -d
if [ $? = '0' ]; then
  green "${myFILE} 安装成功  端口:${myPORT}"
  yellow "其他注意事项⚠️⚠️⚠️： admin@example.com：changeme"
  green "npm：Block。。force。。"
    green "IP参考"
  curl ifconfig.me
  ip addr show docker0
fi

elif [[ "$wiki" = "3" ]] then
# 同步工具——Syncthing
myFILE="syncthing"  
myPORT="63"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
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
      - 63:8384
      - 22000:22000/tcp
      - 22000:22000/udp
      - 21027:21027/udp
    restart: unless-stopped
EOF
lsof -i:${myPORT} && docker-compose up -d
if [ $? = '0' ]; then
  green "${myFILE} 安装成功  端口:${myPORT}"
  yellow "其他注意事项⚠️⚠️⚠️： admin@example.com：changeme"
  green "npm：Block。websock....。force。http2...。"
fi
fi
