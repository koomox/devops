# trojan          
Home: [Link](https://github.com/trojan-gfw/trojan)         
VC runtime: [DownloadLink](https://aka.ms/vs/16/release/VC_redist.x64.exe)          
### 安装 Nginx        
一键安装 Nginx 1.16.1 [查看源文件](/storage/linux/scripts/nginx/install_nginx1161.sh)       
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1161.sh
chmod +x ./install_nginx1161.sh
./install_nginx1161.sh

wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/conf.d/default_trojan.conf
mkdir -p /var/www/html
cd /var/www/html
wget --content-disposition https://html5up.net/paradigm-shift/download
apt install unzip -y
unzip html5up-paradigm-shift.zip
```
设置 iptables        
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/iptables/iptables.http.rules.sh
chmod +x ./iptables.http.rules.sh
./iptables.http.rules.sh

iptables-restore < /etc/iptables.rules
```
安装 Let's Encrypt 证书, 证书路径 `~/.acme.sh/`        
```sh
wget -O -  https://get.acme.sh | sh

source ~/.bashrc

systemctl stop nginx
acme.sh --issue --standalone -d example.com -d www.example.com -d cp.example.com
```

### 安装 trojan      
```sh
NAME=trojan
VERSION=1.13.0
TARBALL="$NAME-$VERSION-linux-amd64.tar.xz"
DOWNLOADURL="https://github.com/trojan-gfw/$NAME/releases/download/v$VERSION/$TARBALL"
wget ${DOWNLOADURL}
tar -xf ${TARBALL}
cd ${NAME}
cp -f trojan /usr/local/bin/trojan
chmod +x /usr/local/bin/trojan
```
配置trojan         
服务端配置文件 `server.json` [source](/storage/linux/scripts/trojan/server-config.json)         
启动文件 `trojan.service` [source](/storage/linux/scripts/trojan/trojan.service)         
```sh
wget -O /etc/systemd/system/trojan.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/trojan/trojan.service

mkdir -p /etc/trojan
wget -O /etc/trojan/config.json https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/trojan/server-config.json
```

```sh
domain=example.com
sed -i "s/password1/${password}/g" /etc/trojan/config.json
sed -i "s/certificate.crt/\/root\/.acme.sh\/${domain}\/fullchain.cer/g" /etc/trojan/config.json
sed -i "s/private.key/\/root\/.acme.sh\/${domain}\/${domain}.key/g" /etc/trojan/config.json
```
```sh
systemctl enable trojan
systemctl start trojan
systemctl status trojan
```
```sh
systemctl enable nginx
systemctl start nginx
systemctl status nginx
```