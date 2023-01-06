#!/bin/bash
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
lsof -i:81 && docker-compose up -d
    if [ $? = '0' ]; then
      echo "npm 安装成功✅✅✅！  端口:81"
      echo "其他注意事项⚠️⚠️⚠️： admin@example.com：changeme"
      echo "IP参考"
      curl ifconfig.me
      ip addr show docker0
    elif [ $? != '0' ]; then
        echo "安装失败，人工检查！"
        exit 1
    fi
