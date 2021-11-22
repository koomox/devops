# Nginx            
Home [Link](https://nginx.org/en/download.html)          
OpenSSL [Link](https://www.openssl.org/source/)         
Zlib [Link](https://zlib.net/)       
pcre [Link](https://ftp.pcre.org/pub/pcre/)         
### 一键安装脚本        
Linux 一键安装脚本 [查看源文件](/storage/linux/scripts/nginx/1.20.2/install.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.20.2/install.sh
sudo chmod +x ./install.sh
sudo ./install.sh
```
一键安装 Nginx 1.18.0 [查看源文件](/storage/linux/scripts/nginx/1.18.0/install.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.18.0/install.sh
sudo chmod +x ./install.sh
sudo ./install.sh
```
```sh
sed -i 's/phpmyadmin/pma/g' /etc/nginx/conf.d/phpmyadmin.conf
cat /etc/nginx/conf.d/phpmyadmin.conf
```
重新启动 nginx       
```sh
systemctl enable nginx
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```   
强制 SSL 网页跳转 [source file](/storage/linux/scripts/nginx/1.16.1/conf.d/default.conf)                         
```sh
sudo wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/conf.d/default.conf
sudo mkdir -p /var/www/html

domain=test.com
sed -i "s/example.com/${domain}/g" /etc/nginx/conf.d/default.conf

mkdir -p /etc/letsencrypt/live/$domain
vim /etc/letsencrypt/live/$domain/fullchain.pem
vim /etc/letsencrypt/live/$domain/privkey.pem
```
安装 Let's Encrypt 证书, 证书路径 `~/.acme.sh/`            
```sh
wget -O -  https://get.acme.sh | sh

source ~/.bashrc

systemctl stop nginx
acme.sh --issue --standalone -d example.com -d www.example.com -d cp.example.com
```
非 80、443 端口，安卓 Let's Encrypt 证书，可以使用 DNS 验证的方式, cloudflare 界面添加 txt 记录。           
```sh
sudo apt install certbot
sudo certbot certonly --manual --preferred-challenges dns -d example.com --register-unsafely-without-email
```
PHP-FPM [source](/storage/linux/scripts/nginx/1.18.0/nginx-ssl-fpm.conf)                
```sh
wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.18.0/nginx-ssl-fpm.conf

domain=test.com
sed -i "s/example.com/${domain}/g" /etc/nginx/conf.d/default.conf

mkdir -p /etc/letsencrypt/live/$domain
vim /etc/letsencrypt/live/$domain/fullchain.pem
vim /etc/letsencrypt/live/$domain/privkey.pem
```
### cdnjs         
nginx 配置文件 [source](/storage/linux/scripts/nginx/1.16.1/conf.d/cdnjs.conf)           
```sh
wget -O /etc/nginx/conf.d/cdnjs.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/conf.d/cdnjs.conf
```
一键构建 cdnjs [source](/storage/linux/scripts/cdnjs/deploy.sh)          
```sh
wget -O deploy_cdnjs.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/cdnjs/deploy.sh
chmod +x ./deploy_cdnjs.sh
./deploy_cdnjs.sh
```