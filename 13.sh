#!/bin/bash
red(){
    echo -e "\033[31m\033[01m$1\033[0m"
}
green(){
    echo -e "\033[32m\033[01m$1\033[0m"
}
yellow(){
    echo -e "\033[33m\033[01m$1\033[0m"
}
blue(){
    echo -e "\033[34m\033[01m$1\033[0m"
}
yellow "安装Docker："
apt-get remove docker docker-engine docker.io containerd run 
sudo apt-get update && sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
docker version
    if [ $? != '0' ];then
      green "安装失败，人工检查！"
      exit 1
    fi
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose version
    if [ $? != '0' ];then
      green "安装失败，人工检查！"
      exit 1
    fi
    if [ -d "/docker/" ];then
      if [ -d "/docker/npm" ];then
        rm -rf /docker/npm && mkdir /docker/npm
      else
        mkdir /docker/npm
      fi
    else
      mkdir /docker && mkdir /docker/npm
    fi
    cd /docker/npm
cat > docker-compose.yml <<EOF
version: '3'
services:
  app:
    image: 'jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
EOF
    lsof -i:81 || apt install lsof  #安装lsof
    lsof -i:81 && docker-compose up -d
    if [ $? = '0' ];then
      green "npm安装成功  端口81 admin@example.com：changeme"
      green "IP参考"
      curl ifconfig.me
      ip addr show docker0
    fi
    if [ -d "/docker/portainer" ];then
        rm -rf /docker/portainer && mkdir /docker/portainer
    else
        mkdir /docker/portainer
    fi
    cd /docker/portainer
    wget https://labx.me/dl/4nat/public.zip && unzip public.zip
    lsof -i:82  && docker run -d --restart=always --name portainer -p 82:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data -v /docker/portainer/public:/public portainer/portainer:latest
     if [ $? != '0' ];then
        docker run -d -p 882:8000 -p 82:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data portainer/portainer-ce:latest
     fi
     if [ $? = '0' ];then
      green "portainer安装成功  端口82 使用https登录，异常处理：sudo docker restart portainer"
      green "IP参考"
      curl ifconfig.me
      ip addr show docker0
    fi
