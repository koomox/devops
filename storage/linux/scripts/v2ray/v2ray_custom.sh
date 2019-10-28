#!/bin/bash
user_uuid=$(cat /proc/sys/kernel/random/uuid)
path_uuid=$(cat /proc/sys/kernel/random/uuid)
port=10000
alterId=64
wget -O /etc/v2ray/config.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/v2ray/websocket_tls/server.json
sed -i "s/20e4d377-725a-4f30-81a9-4dc42272c093/${user_uuid}/g" /etc/v2ray/config.json
sed -i "s/2b494de7-64a1-46f8-be61-9d600d8f34d9/${path_uuid}/g" /etc/v2ray/config.json
sed -i "s/2b494de7-64a1-46f8-be61-9d600d8f34d9/${path_uuid}/g" /etc/nginx/conf.d/v2ray.conf
sed -i "s/1080/${port}/g" /etc/v2ray/config.json
sed -i "s/127.0.0.1:1080/127.0.0.1:${port}/g" /etc/nginx/conf.d/v2ray.conf
cat /etc/v2ray/config.json
echo "user_uuid = ${user_uuid}"
echo "path_uuid = ${path_uuid}"

systemctl stop v2ray
systemctl start v2ray
systemctl status v2ray

local_addr="0.0.0.0"
local_port=1080
remote_addr="example.com"
remote_port=443
alterId=64
wget -O /etc/v2ray/config-client.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/v2ray/websocket_tls/client.json
sed -i "s/127.0.0.1/${local_addr}/g" /etc/v2ray/config-client.json
sed -i "s/1080/${local_port}/g" /etc/v2ray/config-client.json
sed -i "s/example.com/${remote_addr}/g" /etc/v2ray/config-client.json
sed -i "s/443/${remote_port}/g" /etc/v2ray/config-client.json
sed -i "s/20e4d377-725a-4f30-81a9-4dc42272c093/${user_uuid}/g" /etc/v2ray/config-client.json
sed -i "s/2b494de7-64a1-46f8-be61-9d600d8f34d9/${path_uuid}/g" /etc/v2ray/config-client.json
sed -i "s/128/${alterId}/g" /etc/v2ray/config-client.json