# Nginx            
### 一键安装脚本        
Linux 一键安装脚本 [查看源文件](../storage/linux/scripts/nginx/install_nginx1142.sh)         
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1142.sh -o /tmp/install_nginx1142.sh
chmod +x /tmp/install_nginx1142.sh
/tmp/install_nginx1142.sh
```
Linux 下载 nginx 相关文件打包后，上次至 Firefox Send。             
```sh
curl -s https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/download_nginx1142.sh -o /tmp/download_nginx1142.sh
chmod +x /tmp/download_nginx1142.sh
/tmp/download_nginx1142.sh
```
一键安装 Nginx 1.16.0 [查看源文件](../storage/linux/scripts/nginx/install_nginx1160.sh)         
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1160.sh
chmod +x ./install_nginx1160.sh
./install_nginx1160.sh
```

```sh
sed -i 's/localhost/*.com www.*.com/g' /etc/nginx/conf.d/*.com.conf
sed -i 's/$domain/*.com/g' /etc/nginx/conf.d/*.com.conf
sed -i 's/\/var\/www\/html/\/${public_path}/g' /etc/nginx/conf.d/*.com.conf
```
```sh
mkdir -p /etc/letsencrypt/live/$domain
touch /etc/letsencrypt/live/$domain/fullchain.pem
touch /etc/letsencrypt/live/$domain/privkey.pem
```
```sh
sed -i 's/phpmyadmin/pma/g' /etc/nginx/conf.d/phpmyadmin.conf
cat /etc/nginx/conf.d/phpmyadmin.conf
```
```sh
systemctl enable nginx
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```
```sh
echo "hello world" > /var/www/letsencrypt/index
```
### SSL        
一键安装二进制版 Nginx 1.16.1 [source file](/storage/linux/scripts/nginx/1.16.1/install.sh)             
```sh
wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/install.sh
chmod +x ./install.sh
./install.sh

wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/conf.d/default.conf
mkdir -p /var/www/html
cd /var/www/html
wget --content-disposition https://html5up.net/paradigm-shift/download
apt install unzip -y
unzip html5up-paradigm-shift.zip
```
安装 Let's Encrypt 证书, 证书路径 `~/.acme.sh/`            
```sh
wget -O -  https://get.acme.sh | sh

source ~/.bashrc

systemctl stop nginx
acme.sh --issue --standalone -d example.com -d www.example.com -d cp.example.com
```
强制 SSL 网页跳转 [source file](/storage/linux/scripts/nginx/1.16.1/conf.d/default.conf)           
```sh
wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/conf.d/default.conf

domain=test.com
sed -i 's/$domain/'"$domain"'/g' /etc/nginx/conf.d/default.conf

mkdir -p /etc/letsencrypt/live/$domain
vim /etc/letsencrypt/live/$domain/fullchain.pem
vim /etc/letsencrypt/live/$domain/privkey.pem
```