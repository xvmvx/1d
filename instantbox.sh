#!/bin/sh
#
# 安装Instant Box脚本。 首页：https://github.com/instantbox/instantbox。
# 用法：
#  mkdir instantbox && cd $_
#  bash <(curl -sSL https://raw.githubusercontent.com/instantbox/instantbox/master/init.sh)"
#  docker-compose up -d
#

check_cmd() {
    command -v "$1" >/dev/null 2>&1
}

echo "准备安装instantbox, 等待..."
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

curl -sSLO https://raw.githubusercontent.com/instantbox/instantbox/master/docker-compose.yml

echo "输入你的IP，默认回车: "
read IP
echo "输入你的端口，默认回车(8888): "
read PORT

[  -z "$IP" ] || sed -i -e "s/SERVERURL=$/SERVERURL=$IP/" docker-compose.yml
[  -z "$PORT" ] || sed -i -e "s/8888:80/$PORT:80/" docker-compose.yml

echo "已完成设置! "
echo "运行 'docker-compose up -d' 成功后在浏览器打开 http://${IP:-localhost}:${PORT:-8888} "
