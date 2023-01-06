#!/bin/bash
myFILE="filerun"  
myPORT="73"
cat > docker-compose.yml <<EOF
version: '2'
services:
  db:    # 数据库服务
    image: mariadb:10.1
    environment:
      MYSQL_ROOT_PASSWORD: Guwei888  # 数据库root用户的密码，自行修改
      MYSQL_USER: goodway   # 数据库用户名，自行修改
      MYSQL_PASSWORD: Guwei888 # 数据库密码，自行修改
      MYSQL_DATABASE: filerun #数据库名，自行修改
    volumes:
      - /docker/filerun/db:/var/lib/mysql  # 挂载路径，冒号左边可以自己修改成VPS本地的路径，冒号右边为Docker容器内部路径，不能修改
    restart: always

  web:  # 网页服务
    image: filerun/filerun
    environment:
      FR_DB_HOST: db
      FR_DB_PORT: 3306
      FR_DB_NAME: filerun
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
      - "73:80"  # Docker内部的80端口映射到VPS本地的8000端口，8000端口记得防火墙打开（宝塔、阿里云、腾讯云）
    volumes:
      - /docker/filerun/html:/var/www/html  # 挂载路径，冒号左边可以自己修改成VPS本地的路径，冒号右边为Docker容器内部路径，不能修改
      - /docker/filerun/user-files:/user-files  # 挂载路径，冒号左边可以自己修改成VPS本地的路径，冒号右边为Docker容器内部路径，不能修改
EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    green "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    yello "其他注意事项⚠️⚠️⚠️： https://blog.laoda.de/archives/docker-compose-install-filerun"
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
