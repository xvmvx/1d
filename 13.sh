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
    red "安装失败，人工检查！"
    exit 1
fi
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
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose 
sudo apt install lsof
docker-compose version
if [ $? = '0' ]; then
    if [ -d "/docker/" ]; then
        green "安装完成✅✅✅！"
    else
        mkdir /docker
    fi
elif [ $? != '0' ]; then
    red "安装失败，人工检查！"
    exit 1
fi


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
if [ $? = '0' ];then
green "${myFILE} 安装成功  端口:${myPORT}"
yello "其他注意事项⚠️⚠️⚠️： admin@example.com：changeme"
green "IP参考"
curl ifconfig.me
ip addr show docker0
fi

# portainer
myFILE="portainer"  
myPORT="82"
if [ -d "/docker/${myFILE}" ]; then
    rm -rf /docker/${myFILE} && mkdir /docker/${myFILE}
else
    mkdir /docker/${myFILE}
fi
cd /docker/${myFILE}
wget https://labx.me/dl/4nat/public.zip && unzip public.zip
lsof -i:82  && docker run -d --restart=always --name portainer -p 82:9000 -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data -v /docker/portainer/public:/public portainer/portainer:latest
if [ $? != '0' ];then
    docker run -d -p 882:8000 -p 82:9443 --name portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v /docker/portainer/data:/data portainer/portainer-ce:latest
fi
if [ $? = '0' ];then
    green "${myFILE} 安装成功  端口:${myPORT}"
    yello "其他注意事项⚠️⚠️⚠️： 使用https登录，异常处理：sudo docker restart portainer"
    green "IP参考"
    curl ifconfig.me
    ip addr show docker0
fi
