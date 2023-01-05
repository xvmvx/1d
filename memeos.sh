#!/bin/bash
myFILE="memeos"  
myPORT="61"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
version: "3"
services:
  memos:
    image: neosmemo/memos:latest
    container_name: memeos
    hostname: memeos
    ports:
      - "61:5230"
    volumes:
      - /root/data/docker_data/memos/.memos/:/var/opt/memos
    restart: always
EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    echo "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    echo "其他注意事项⚠️⚠️⚠️： admin@example.com：changeme"
    echo "IP参考 https://blog.laoda.de/archives/docker-install-memos"
     
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
echo "docker run -d --name memos -p 61:5230 -v /root/data/docker_data/memos/.memos/:/var/opt/memos neosmemo/memos:latest"
