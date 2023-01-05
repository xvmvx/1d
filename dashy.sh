#!/bin/bash
myFILE="dashy"  
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
    dashy:
        ports:
            - '72:80'
        volumes:
            - '/root/data/docker_data/dashy/public/conf.yml:/app/public/conf.yml'
            - '/root/data/docker_data/dashy/icons:/app/public/item-icons/icons'
        container_name: dashy
        restart: unless-stopped
        image: 'lissy93/dashy:latest'
EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    green "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    yello "其他注意事项⚠️⚠️⚠️： https://blog.laoda.de/archives/docker-compose-install-dashy"
    green "IP参考"
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

