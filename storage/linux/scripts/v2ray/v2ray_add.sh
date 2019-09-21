#!/bin/bash
read -p "input user name: " USERNAME

function rand(){
    min=$1
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}
 
port=$(rand 20000 30000)

user_uuid=$(cat /proc/sys/kernel/random/uuid)
path_uuid=$(cat /proc/sys/kernel/random/uuid)
wget -O /etc/v2ray/$USERNAME.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/v2ray/websocket_tls/server.json
wget -O /etc/nginx/conf.d/v2ray-$USERNAME.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/conf.d/v2ray.conf

sed -i 's/$path_uuid/'"$path_uuid"'/g' /etc/nginx/conf.d/v2ray-$USERNAME.conf
sed -i 's/$path_uuid/'"$path_uuid"'/g' /etc/v2ray/$USERNAME.conf

sed -i 's/$port/'"$port"'/g' /etc/nginx/conf.d/v2ray-$USERNAME.conf
sed -i 's/$port/'"$port"'/g' /etc/v2ray/$USERNAME.conf

sed -i '$c '"include conf.d\/v2ray-$USERNAME.conf;\n}" /etc/nginx/conf.d/default.conf

nohup /usr/bin/v2ray/v2ray -config /etc/v2ray/v2ray-$USERNAME.conf

systemctl stop nginx
systemctl start nginx



echo "========= /etc/nginx/conf.d/v2ray-$USERNAME.conf ============"
cat /etc/nginx/conf.d/v2ray-$USERNAME.conf
echo "========= /etc/v2ray/$USERNAME.conf ============"
cat /etc/v2ray/$USERNAME.conf
echo "=============== UUID ===================="
echo "port = ${port}"
echo "user_uuid = ${user_uuid}"
echo "path_uuid = ${path_uuid}"