#!/bin/bash
# 定义变量
echo -e "请输入绑定域名（abc.com）："
		read -e -p "(输入为空则取消):" new_domain
		[[ -z "${new_domain}" ]] && echo "取消..." && exit 1
myDOMAIN=${new_domain}
myIP=$(curl ip.sb)
myFILE=
# 升级系统
sudo apt update && sudo apt upgrade
sudo apt install unattended-upgrades
# 更换端口
#sudo echo" ">>/etc/ssh/sshd_config
source ssh22.sh
sudo systemctl restart sshd


# 添加用户
# f2b
# sudo apt install fail2ban
source f2b.sh
# ufw防火墙
# sudo apt install ufw
# docker
sudo apt-get remove docker docker-engine docker.io containerd runc
sudo apt-get update && sudo apt-get install  ca-certificates  curl  gnupg  lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
 sudo apt-get update || sudo chmod a+r /etc/apt/keyrings/docker.gpg && sudo apt-get update
 sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
 if [ $? = '0' ]; then
  echo '安装成功【docker】'
 else
  curl -fsSL https://get.docker.com | bash -s docker
 fi
# docker-dompose
sudo apt install docker-compose || curl -L https://github.com/docker/compose/releases/download/v2.14.0/docker-compose-linux-`uname -m` > ./docker-compose
 if [ $? = '0' ]; then
  echo '安装成功【docker】【docker-compose】'
 else
  fibash <(curl -sSL https://gitee.com/SuperManito/LinuxMirrors/raw/main/DockerInstallation.sh)
 fi

#matrix
# 创建docker网络
sudo docker network create --driver=bridge --subnet=10.15.0.10/24 --gateway=10.15.0.10 matrix_net
# 创建矩阵目录
sudo mkdir matrix && cd matrix
# yml 文件
cat > docker-compose.yml <<EOF
version: '2.3'
services:
  postgres:
    image: postgres:14
    restart: unless-stopped
    networks:
      default:
        ipv4_address: 10.15.0.12
    volumes:
     - ./postgresdata:/var/lib/postgresql/data

    # These will be used in homeserver.yaml later on
    environment:
     - POSTGRES_DB=synapse1
     - POSTGRES_USER=synapse1
     - POSTGRES_PASSWORD=STRONGPASSWORD1
     
  element:
    image: vectorim/element-web:latest
    restart: unless-stopped
    volumes:
      - ./element-config.json:/app/config.json
    networks:
      default:
        ipv4_address: 10.15.0.13
        
  synapse:
    image: matrixdotorg/synapse:latest
    restart: unless-stopped
    networks:
      default:
        ipv4_address: 10.15.0.14
    volumes:
     - ./synapse:/data

networks:
  default:
    external:
      name: matrix_net
EOF
# 配置文件
cat > element-config.json <<EOF
{
    "default_server_config": {
        "m.homeserver": {
            "base_url": "https://matrix.haoo.host",
            "server_name": "matrix.haoo.host"
        },
        "m.identity_server": {
            "base_url": "https://vector.im"
        }
    },

    # "default_server_name": "matrix.org",
    "brand": "Element",
    "integrations_ui_url": "https://scalar.vector.im/",
    "integrations_rest_url": "https://scalar.vector.im/api",
    "integrations_widgets_urls": [
        "https://scalar.vector.im/_matrix/integrations/v1",
        "https://scalar.vector.im/api",
        "https://scalar-staging.vector.im/_matrix/integrations/v1",
        "https://scalar-staging.vector.im/api",
        "https://scalar-staging.riot.im/scalar/api"
    ],
    "hosting_signup_link": "https://element.io/matrix-services?utm_source=element-web&utm_medium=web",
    "bug_report_endpoint_url": "https://element.io/bugreports/submit",
    "uisi_autorageshake_app": "element-auto-uisi",
    "showLabsSettings": true,
    "roomDirectory": {
        "servers": ["matrix.org", "gitter.im", "libera.chat"]
    },
    "enable_presence_by_hs_url": {
        "https://matrix.org": false,
        "https://matrix-client.matrix.org": false
    },
    "terms_and_conditions_links": [
        {
            "url": "https://element.io/privacy",
            "text": "Privacy Policy"
        },
        {
            "url": "https://element.io/cookie-policy",
            "text": "Cookie Policy"
        }
    ],
    "hostSignup": {
        "brand": "Element Home",
        "cookiePolicyUrl": "https://element.io/cookie-policy",
        "domains": ["matrix.org"],
        "privacyPolicyUrl": "https://element.io/privacy",
        "termsOfServiceUrl": "https://element.io/terms-of-service",
        "url": "https://ems.element.io/element-home/in-app-loader"
    },
    "sentry": {
        "dsn": "https://029a0eb289f942508ae0fb17935bd8c5@sentry.matrix.org/6",
        "environment": "develop"
    },
    "posthog": {
        "projectApiKey": "phc_Jzsm6DTm6V2705zeU5dcNvQDlonOR68XvX2sh1sEOHO",
        "apiHost": "https://posthog.element.io"
    },
    "privacy_policy_url": "https://element.io/cookie-policy",
    "features": {
        "feature_spotlight": true,
        "feature_video_rooms": true
    },
    "element_call": {
        "url": "https://element-call.netlify.app"
    },
    "map_style_url": "https://api.maptiler.com/maps/streets/style.json?key=fU3vlMsMn4Jb6dnEIFsx"
}
EOF
# 生成synapse配置文件
sudo docker run -it --rm \
    -v "$HOME/matrix/synapse:/data" \
    -e SYNAPSE_SERVER_NAME=haoo.host \
    -e SYNAPSE_REPORT_STATS=yes \
    matrixdotorg/synapse:latest generate
# 修改数据库配置
#database:
#  name: sqlite3
#  args:
#    database: /data/homeserver.db
database:
  name: psycopg2
  args:
    user: synapse
    password: STRONGPASSWORD
    database: synapse
    host: postgres
    cp_min: 5
    cp_max: 10
# 部署
sudo docker-compose up -d

#  创建新用户
#    访问docker shell：
sudo docker exec -it matrix_synapse_1 bash
register_new_matrix_user -c /data/homeserver.yaml http://localhost:8008
#    按照屏幕上的提示操作
进入exit离开集装箱的外壳
允许任何人在homeserver.yaml中将帐户设置为true。这不是推荐的。


# caddy
sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo apt-key add -
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list
sudo apt update 
sudo apt install caddy
sudo systemctl status caddy

# Caddyfile
cat > Caddyfile <<EOF
haoo.host {
  reverse_proxy /_matrix/*  10.15.0.14:8008
  reverse_proxy /_synapse/client/*  10.15.0.14:8008
  
  header {
    X-Content-Type-Options nosniff
    Referrer-Policy  strict-origin-when-cross-origin
    Strict-Transport-Security "max-age=63072000; includeSubDomains;"
    Permissions-Policy "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=(), interest-cohort=()"
    X-Frame-Options SAMEORIGIN
    X-XSS-Protection 1
    X-Robots-Tag none
    -server
  }
}

element.haoo.host {
  encode zstd gzip
  reverse_proxy 10.15.0.13:80

  header {
    X-Content-Type-Options nosniff
    Referrer-Policy  strict-origin-when-cross-origin
    Strict-Transport-Security "max-age=63072000; includeSubDomains;"
    Permissions-Policy "accelerometer=(), camera=(), geolocation=(), gyroscope=(), magnetometer=(), microphone=(), payment=(), usb=(), interest-cohort=()"
    X-Frame-Options SAMEORIGIN
    X-XSS-Protection 1
    X-Robots-Tag none
    -server
  }
}
EOF
