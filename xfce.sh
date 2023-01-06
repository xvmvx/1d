#!/bin/bash
myFILE="xfce"  
myPORT="62"
cat > docker-compose.yml <<EOF
version: '3.5'

services:
    ubuntu-xfce-vnc:
        container_name: xfce
        image: imlala/ubuntu-xfce-vnc-novnc:latest
        shm_size: "1gb"  # 防止高分辨率下Chromium崩溃,如果内存足够也可以加大一点点
        ports:
            - 62:5900   # TigerVNC的服务端口（保证端口是没被占用的，冒号右边的端口不能改，左边的可以改）
            - 63:6080   # noVNC的服务端口，注意事项同上
        environment: 
            - VNC_PASSWD=Guwei888    # 改成你自己想要的密码
            - GEOMETRY=1280x720      # 屏幕分辨率，800×600/1024×768诸如此类的可自己调整
            - DEPTH=24               # 颜色位数16/24/32可用，越高画面越细腻，但网络不好的也会更卡
        volumes: 
            - ./Downloads:/root/Downloads  # Chromium/Deluge/qBittorrent/Transmission下载的文件默认保存位置都是root/Downloads下
            - ./Documents:/root/Documents  # 映射一些其他目录
            - ./Pictures:/root/Pictures
            - ./Videos:/root/Videos
            - ./Music:/root/Music
        restart: unless-stopped
EOF
lsof -i:${myPORT} && docker-compose up -d
    if [ $? = '0' ]; then
    echo "${myFILE} 安装成功✅✅✅！  端口:${myPORT}"
    echo "其他注意事项⚠️⚠️⚠️： https://blog.laoda.de/archives/install-ubuntu-desktop"
    echo "IP参考"
    curl ifconfig.me
    ip addr show docker0

    elif [ $? != '0' ]; then
        echo "安装失败，人工检查！"
        exit 1
    fi
