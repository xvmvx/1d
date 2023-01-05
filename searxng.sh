#!/bin/bash
myFILE="searxng-docker"  
myPORT="71"
git clone https://github.com/searxng/searxng-docker.git
cd searxng-docker/
cat > docker-compose.yml <<EOF
version: '3.7'

services:
# 我们注释掉caddy的内容
  #  caddy:
  #  container_name: caddy
  #  image: caddy:2-alpine
  #  network_mode: host
  #  volumes:
  #    - ./Caddyfile:/etc/caddy/Caddyfile:ro
  #    - caddy-data:/data:rw
  #    - caddy-config:/config:rw
  #  environment:
  #    - SEARXNG_HOSTNAME=${SEARXNG_HOSTNAME:-http://localhost:80}
  #    - SEARXNG_TLS=${LETSENCRYPT_EMAIL:-internal}
  #  cap_drop:
  #    - ALL
  #  cap_add:
  #    - NET_BIND_SERVICE
  #    - DAC_OVERRIDE

  redis:
    container_name: redis
    image: "redis:alpine"
    command: redis-server --save "" --appendonly "no"
    networks:
      - searxng
    tmpfs:
      - /var/lib/redis
    cap_drop:
      - ALL
    cap_add:
      - SETGID
      - SETUID
      - DAC_OVERRIDE

  searxng:
    container_name: searxng
    image: searxng/searxng:latest
    networks:
      - searxng
    ports:
     - "71:8080"   # 这个冒号左边的端口可以更改，右边的不要改
    volumes:
      - ./searxng:/etc/searxng:rw
    environment:
      - SEARXNG_BASE_URL=https://${SEARXNG_HOSTNAME:-localhost}/
    cap_drop:
      - ALL
    cap_add:
      - CHOWN
      - SETGID
      - SETUID
      - DAC_OVERRIDE
    logging:
      driver: "json-file"
      options:
        max-size: "1m"
        max-file: "1"
networks:
  searxng:
    ipam:
      driver: default

        #volumes:
        #caddy-data:
        #caddy-config:
EOF
echo "SEARXING_HOSTNAME=95118.tech">>.env
sed -i "s|ultrasecretkey|$(openssl rand -hex 32)|g" searxng/settings.yml # 生成一个密钥
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    green "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    yello "其他注意事项⚠️⚠️⚠️： https://blog.laoda.de/archives/docker-compose-install-searxng"
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

