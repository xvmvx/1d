#!/bin/bash
myFILE="guacamole"  
myPORT="65"
cat > docker-compose.yml <<EOF
version: "3"
services:
  guacamole:
    image: jwetzell/guacamole
    container_name: guacamole
    volumes:
      - ./postgres:/config
    ports:
      - 65:8080
volumes:
  postgres:
    driver: local
EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    echo "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    echo "其他注意事项⚠️⚠️⚠️： https://blog.laoda.de/archives/docker-install-guacamole"
    fi
