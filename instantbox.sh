#!/bin/sh
#
# 安装Instant Box脚本。 首页：https://github.com/instantbox/instantbox。
# 用法：
#  mkdir instantbox && cd $_
#  bash <(curl -sSL https://raw.githubusercontent.com/instantbox/instantbox/master/init.sh)"
#  docker-compose up -d
#   测试网络是否连通：docker exec -it test2 ping test1
#   增加一个名为app_net的网络：docker network create app_net
#       docker network create --subnet=172.172.0.1/24 goodway
#   docker-compose.yml 需要添加   1.
#       networks:
#          nginx_net:
#            external:
#              name: web_net
#   并且还要在services里添加     2.
#               networks:
#                 nginx_net:
#                   ipv4_address: 172.32.0.4
#
#
check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

echo "准备安装portainer, 等待..."
echo ""

if check_cmd docker; then
    echo "docker已安装"
else
    echo "docker没有安装，请安装"
    exit 1
fi

if check_cmd docker-compose; then
    echo "docker-compose已安装"
else
    curl -sSL https://raw.githubusercontent.com/docker/compose/master/script/run/run.sh > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose || exit 1
fi
myFILE="portainer"  
myPORT="82"
myIP=$(ip route get 1 | awk '{print $7;exit}')
echo -n "输入你的容器名称，默认回车: "; ${myFILE} 
read Name
echo -n "输入你的IP，默认回车: " ${myIP} 
read IP
echo "输入你的端口，默认回车: "${myPORT} 
read PORT

if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi

cd /docker/${myFILE} && cat > docker-compose.yml <<EOF
version: "3"

networks:
  nginx_net:
    external:
      name: goodway

services:
  portainer:
      image: portainer/portainer
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
        - ~/portainer/data:/data
      networks:
        nginx_net:
          ipv4_address: 172.172.0.1

      ports:
        - 82:9000 
      container_name: portainer
volumes:
    data: 
EOF
# [  -z "$IP" ] || sed -i -e "s/SERVERURL=$/SERVERURL=$IP/" docker-compose.yml
# [  -z "$PORT" ] || sed -i -e "s/8888:80/$PORT:80/" docker-compose.yml

echo "已完成设置! "
echo "运行 'docker-compose up -d' 成功后在浏览器打开 http://${IP:-localhost}:${PORT:-8888} "
lsof -i:${myPORT} && sudo docker-compose up -d
    if [ $? = '0' ]; then
        green "${myFILE} 安装成功✅✅✅  端口:${myPORT}"
        yello "其他注意事项⚠️⚠️⚠️： 使用https登录，异常处理：sudo docker restart portainer"
        green "IP参考"
        curl ifconfig.me
        ip addr show docker0
    elif [ $? != '0' ]; then
        red "安装失败，人工检查！"
        exit 1
    fi
