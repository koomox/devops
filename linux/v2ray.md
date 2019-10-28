# V2ray              
Home: [Link](https://www.v2ray.com/)              
github: [Link](https://github.com/v2ray/v2ray-core)           
安装文档: [Link](https://www.v2ray.com/chapter_00/install.html)            
### 安装        
V2Ray 提供了一个在 Linux 中的自动化安装脚本。这个脚本会自动检测有没有安装过 V2Ray，如果没有，则进行完整的安装和配置；如果之前安装过 V2Ray，则只更新 V2Ray 二进制程序而不更新配置。            

以下指令假设已在 `su` 环境下，如果不是，请先运行 `sudo su`。                

运行下面的指令下载并安装 V2Ray。当 `yum` 或 `apt-get` 可用的情况下，此脚本会自动安装 `unzip` 和 `daemon`。这两个组件是安装 V2Ray 的必要组件。如果你使用的系统不支持 `yum` 或 `apt-get`，请自行安装 `unzip` 和 `daemon`           
[查看源文件](https://github.com/v2ray/v2ray-core/blob/master/release/install-release.sh)            
```sh
bash <(curl -L -s https://install.direct/go.sh)

bash <(curl -L -s https://raw.githubusercontent.com/v2ray/v2ray-core/master/release/install-release.sh)
```
此脚本会自动安装以下文件：          
 * /usr/bin/v2ray/v2ray：V2Ray 程序；
 * /usr/bin/v2ray/v2ctl：V2Ray 工具；
 * /etc/v2ray/config.json：配置文件；
 * /usr/bin/v2ray/geoip.dat：IP 数据文件
 * /usr/bin/v2ray/geosite.dat：域名数据文件        

### Alpine Linux 安装 V2ray            
```sh
mkdir -p /tmp/v2ray && cd /tmp/v2ray
wget https://github.com/v2ray/v2ray-core/releases/download/v4.20.0/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
cp v2ray v2ctl geoip.dat geosite.dat -t /usr/bin
chmod +x /usr/bin/v2ray
chmod +x /usr/bin/v2ctl
```
Alpine Linux 添加 v2ray 自启动文件          
```sh
touch /etc/local.d/v2ray.start
echo "nohup /usr/bin/v2ray -config /etc/v2ray/config.json &" > /etc/local.d/v2ray.start
chmod +x /etc/local.d/v2ray.start
rc-update add local
```
### Nginx            
nginx 配置文件 `/etc/nginx/conf.d/default.conf` [source file](/storage/linux/scripts/nginx/1.16.0/conf.d/default_v2ray.conf)        
nginx v2ray 配置文件 `/etc/nginx/conf.d/v2ray.conf` [source file](/storage/linux/scripts/nginx/1.16.0/conf.d/v2ray.conf)           
```sh
mkdir -p /etc/nginx/conf.d
wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/conf.d/default_v2ray.conf
wget -O /etc/nginx/conf.d/v2ray.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/conf.d/v2ray.conf

domain=test.com
sed -i "s/example.com/${domain}/g" /etc/nginx/conf.d/default.conf

mkdir -p /etc/letsencrypt/live/$domain
vim /etc/letsencrypt/live/$domain/fullchain.pem
vim /etc/letsencrypt/live/$domain/privkey.pem

cd /var/www/html
wget --content-disposition https://html5up.net/paradigm-shift/download
```
```sh
systemctl enable nginx
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```
### v2ray 配置文件       
服务端配置文件 `/etc/v2ray/config.json` [source file](/storage/linux/scripts/v2ray/websocket_tls/server.json)          
nginx v2ray 配置文件 `/etc/nginx/conf.d/v2ray.conf` [source file](/storage/linux/scripts/nginx/1.16.0/conf.d/v2ray.conf)       
```sh
port=10000
user_uuid=$(cat /proc/sys/kernel/random/uuid)
path_uuid=$(cat /proc/sys/kernel/random/uuid)
wget -O /etc/v2ray/config.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/v2ray/websocket_tls/server.json
sed -i "s/20e4d377-725a-4f30-81a9-4dc42272c093/${user_uuid}/g" /etc/v2ray/config.json
sed -i "s/2b494de7-64a1-46f8-be61-9d600d8f34d9/${path_uuid}/g" /etc/v2ray/config.json
sed -i "s/2b494de7-64a1-46f8-be61-9d600d8f34d9/${path_uuid}/g" /etc/nginx/conf.d/v2ray.conf
sed -i "s/1080/${port}/g" /etc/v2ray/config.json
sed -i "s/127.0.0.1:1080/127.0.0.1:${port}/g" /etc/nginx/conf.d/v2ray.conf
cat /etc/v2ray/config.json
echo "user_uuid = ${user_uuid}"
echo "path_uuid = ${path_uuid}"
```
```sh
systemctl enable v2ray
systemctl stop v2ray
systemctl start v2ray
systemctl status v2ray
```
客户端配置文件 `/etc/v2ray/config.json` [source](/storage/linux/scripts/v2ray/websocket_tls/client.json)         
```sh
wget -O /etc/v2ray/config.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/v2ray/websocket_tls/client.json

local_addr="0.0.0.0"
local_port=
remote_addr=""
remote_port=443
user_uuid=
path_uuid=
alterId=64

sed -i "s/127.0.0.1/${local_addr}/g" /etc/v2ray/config.json
sed -i "s/1080/${local_port}/g" /etc/v2ray/config.json
sed -i "s/example.com/${remote_addr}/g" /etc/v2ray/config.json
sed -i "s/443/${remote_port}/g" /etc/v2ray/config.json
sed -i "s/20e4d377-725a-4f30-81a9-4dc42272c093/${user_uuid}/g" /etc/v2ray/config.json
sed -i "s/2b494de7-64a1-46f8-be61-9d600d8f34d9/${path_uuid}/g" /etc/v2ray/config.json
sed -i "s/128/${alterId}/g" /etc/v2ray/config.json

cat /etc/v2ray/config.json
```