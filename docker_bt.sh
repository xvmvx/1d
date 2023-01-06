#!/bin/bash
check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

echo "准备安装宝塔, 等待..."
echo ""

if check_cmd docker; then
    echo "docker已安装"
else
    echo "docker没有安装，请安装"
    curl -sSL https://get.docker.com/ | sh
    systemctl start docker
    systemctl enable docker
fi

if check_cmd docker-compose; then
    echo "docker-compose已安装"
else
    curl -sSL https://raw.githubusercontent.com/docker/compose/master/script/run/run.sh > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose || exit 1
fi
docker run -tid --name baota --net=host --privileged=true --shm-size=1g --restart always -v ~/wwwroot:/www/wwwroot pch18/baota
docker run -tid --name baota -p 80:80 -p 443:443 -p 8888:8888 -p 888:888 --privileged=true --shm-size=1g --restart always -v ~/wwwroot:/www/wwwroot pch18/baota

echo "登陆地址 http://{{面板ip地址}}:8888"
echo "初始账号 username"
echo "初始密码 password"
