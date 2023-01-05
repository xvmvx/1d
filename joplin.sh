#!/bin/bash
myFILE="joplin"  
myPORT="62"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
cat > docker-compose.yml <<EOF
# This is a sample docker-compose file that can be used to run Joplin Server
# along with a PostgreSQL server.
#
# Update the following fields in the stanza below:
#
# POSTGRES_USER
# POSTGRES_PASSWORD
# APP_BASE_URL
#
# APP_BASE_URL: This is the base public URL where the service will be running.
#	- If Joplin Server needs to be accessible over the internet, configure APP_BASE_URL as follows: https://example.com/joplin. 
#	- If Joplin Server does not need to be accessible over the internet, set the the APP_BASE_URL to your server's hostname. 
#     For Example: http://[hostname]:22300. The base URL can include the port.
# APP_PORT: The local port on which the Docker container will listen. 
#	- This would typically be mapped to port to 443 (TLS) with a reverse proxy.
#	- If Joplin Server does not need to be accessible over the internet, the port can be mapped to 22300.

version: '3'

services:
    db:
        image: postgres:13
        volumes:
            - ./data/postgres:/var/lib/postgresql/data
        ports:
            - "5432:5432"  # 左边的端口可以更换，右边不要动！
        restart: unless-stopped
        environment:
            - POSTGRES_PASSWORD=changeme # 改成你自己的密码
            - POSTGRES_USER=username  # 改成你自己的用户名
            - POSTGRES_DB=joplin
    app:
        image: joplin/server:latest
        depends_on:
            - db
        ports:
            - "62:22300" # 左边的端口可以更换，右边不要动！
        restart: unless-stopped
        environment:
            - APP_PORT=22300
            - APP_BASE_URL=https://your.domain.com # 改成反代的域名
            - DB_CLIENT=pg
            - POSTGRES_PASSWORD=changeme # 与上面的密码对应！
            - POSTGRES_DATABASE=joplin
            - POSTGRES_USER=username  # 与上面的用户名对应！
            - POSTGRES_PORT=5432 # 与上面右边的对应！
            - POSTGRES_HOST=db

EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    green "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    yello "其他注意事项⚠️⚠️⚠️： https://blog.laoda.de/archives/docker-compose-install-joplin-server"
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
