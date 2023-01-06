#!/bin/bash
myFILE="trilium"  
myPORT="73"
mkdir -p /docker/wikijs && cd /docker/wikijs
cat >docker-compose.yml<< EOF
version: '3'
services:
  trilium-cn:
    image: nriver/trilium-cn
    restart: always
    ports:
      - "73:8080"
    volumes:
      # 把同文件夹下的 trilium-data 目录映射到容器内
      - ./trilium-data:/root/trilium-data
    environment:
      # 环境变量表示容器内笔记数据的存储路径
      - TRILIUM_DATA_DIR=/root/trilium-data
EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    echo "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    echo "其他注意事项⚠️⚠️⚠️：npm:ca.block.web+for"
    echo "IP参考https://blog.laoda.de/archives/docker-compose-install-trilium"
    curl ifconfig.me
    ip addr show docker0
    elif [ $? != '0' ]; then
        echo "安装失败，人工检查！"
        exit 1
    fi
