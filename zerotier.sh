#!/bin/bash
curl -s https://install.zerotier.com | sudo bash
read -p "添加你的   虚拟网络     ：" myVIP
sudo zerotier-cli join ${myVIP}
cd /var/lib/zerotier-one
sudo zerotier-idtool initmoon identity.public >> moon.json

str1=' "stableEndpoints": [] '  #查找的字符串
ServerIP=$(curl ip.sb)  
newstr=' "stableEndpoints": ["${ServerIP}/9993"] '  #新字符串
filename="moon.json"  #被替换的文件名
line=`sed -n '/$str1/=' $filename`  #获取指定字符串的行号
sed -i "$line d" $filename  #删除这行
sed -i "$line i$newstr" $filename  #在删除的行插入新字符串
line=`sed -n '/pam_authenticator.so/=' ${sshd}`
if(($line >0)); then
sed -i "$line d" $sshd
sed -i "$line i $sshd_old" $sshd
fi
sudo zerotier-idtool genmoon moon.json
sudo mkdir moons.d
mv $(find ./ -name "000*.moon") moons.d/$(find ./ -name "000*.moon") 
 sudo systemctl restart zerotier-one
 sudo zerotier-cli orbit ${myVIP} ${myVIP}
 sudo zerotier-cli listpeers
