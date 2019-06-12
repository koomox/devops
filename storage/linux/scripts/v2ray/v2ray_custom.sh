#!/bin/bash
user_uuid=$(cat /proc/sys/kernel/random/uuid)
path_uuid=$(cat /proc/sys/kernel/random/uuid)
wget -O /etc/v2ray/config.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/v2ray/websocket_tls/server.json
sed -i 's/$port/10000/g' /etc/v2ray/config.json
sed -i 's/$user_uuid/'"$user_uuid"'/g' /etc/v2ray/config.json
sed -i 's/$path_uuid/'"$path_uuid"'/g' /etc/v2ray/config.json
cat /etc/v2ray/config.json
echo "user_uuid = ${user_uuid}"
echo "path_uuid = ${path_uuid}"

wget -O /etc/v2ray/config.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/v2ray/websocket_tls/client.json
sed -i 's/$socks_port/10258/g' /etc/v2ray/config.json
sed -i 's/$http_port/10259/g' /etc/v2ray/config.json
sed -i 's/$domain//g' /etc/v2ray/config.json
sed -i 's/$user_uuid//g' /etc/v2ray/config.json
sed -i 's/$path_uuid//g' /etc/v2ray/config.json