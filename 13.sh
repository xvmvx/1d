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
red "############  Docker  #################"
yellow " Docker  基本安装"
yellow " Docker- compose 安装"
yellow " Docker 设置"
yellow " NPM 安装"
yellow " Portainer 安装"
red "安装Docker(1),Docker- compose(2),设置(3),NPM（4),Portainer（5）"
read -p "："  ddd
if [[ "$ddd" = "1" ]]; then
yellow "安装Docker："
apt-get remove docker docker-engine docker.io containerd run 
sudo apt-get update && sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
 echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
 $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
docker version || sudo apt  install docker.io 
    if [ $? = '0' ]; then
        green "安装完成✅✅✅！"
        read -p "继续安装docker-compose（y）："  dc
        if [[ "$dc" = "y" ]]; then
            docker-compose
        fi
    elif [ $? != '0' ]; then
        red "安装失败，人工检查！"
        exit 1
    fi
elif [[ "$ddd" = "2" ]]; then
yellow "安装Docker-compose："
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose 
sudo apt install lsof
docker-compose version
    if [ $? = '0' ]; then
        green "安装完成✅✅✅！"
        read -p "继续优化docker（y）："  ds
        if [[ "$ds" = "y" ]]; then
            ds
        fi
        if [ -d "/docker/" ]; then
            green "/docker/创建！"
        else
            mkdir /docker
        fi
    elif [ $? != '0' ]; then
        red "安装失败，人工检查！"
        exit 1
    fi
elif [[ "$ddd" = "3" ]]; then
cat > /etc/docker/daemon.json <<EOF
{
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "20m",
        "max-file": "3"
    },
    "ipv6": true,
    "fixed-cidr-v6": "fd00:dead:beef:c0::/80",
    "experimental":true,
    "ip6tables":true
}
EOF
sudo systemctl restart docker && sudo systemctl enable docker
     if [ $? = '0' ]; then
        green "优化完成✅✅✅！"
        read -p "继续安装npm（y）："  npm
        if [[ "$npm" = "y" ]]; then
            npm
        fi
    elif [ $? != '0' ]; then
        red "安装失败，人工检查！"
        exit 1
    fi
elif [[ "$ddd" = "4" ]]; then
# npm
myFILE="npm"  
myPORT="81"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
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
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    green "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    yello "其他注意事项⚠️⚠️⚠️： admin@example.com：changeme"
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
elif [[ "$ddd" = "5" ]]; then
# portainer
myFILE="portainer"  
myPORT="82"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE} && cat > docker-compose.yml <<EOF
version: "3"
services:
  portainer:
      image: portainer/portainer
      volumes:
        - /var/run/docker.sock:/var/run/docker.sock
        - ~/portainer/data:/data
      ports:
        - 82:9000 
      container_name: portainer
volumes:
    data: 
EOF
lsof -i:${myPORT} && sudo docker-compose up -d
# wget https://labx.me/dl/4nat/public.zip && unzip public.zip
# lsof -i:82  && docker run -d --restart=always --name portainer -p 82:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data -v /docker/portainer/public:/public portainer/portainer:latest
# if [ $? != '0' ];then
#    docker run -d -p 882:8000 -p 82:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data portainer/portainer-ce:latest
# fi
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
fi
