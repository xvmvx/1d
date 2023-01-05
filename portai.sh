#!/bin/bash
case $(uname -m) in
  x86_64)  
    docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data 6053537/portainer-ce
    if [ $? = '0' ]; then
      inPRO=0
      echo "安装完成✅✅✅！"
    else
      sh -c "$(curl -kfsSl https://gitee.com/expin/public/raw/master/onex86.sh)" && echo "安装完成✅✅✅！"; inPRO=0
   fi
  ;;
  aarch64) 
    docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data 6053537/portainer-ce:linux-arm64
    if [ $? = '0' ]; then
      inPRO=0
      echo "安装完成✅✅✅！"
    else
      sh -c "$(curl -kfsSl https://gitee.com/expin/public/raw/master/one.sh)" && echo "安装完成✅✅✅！"; inPRO=0
    fi
  ;;
esac
 if [ $inPRO != '0' ]; then
  docker pull hub-mirror.c.163.com/6053537/portainer-ce
  docker run -d --restart=always --name="portainer" -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer
fi
