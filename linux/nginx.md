# Nginx            
Home [Link](https://nginx.org/en/download.html)          
OpenSSL [Link](https://www.openssl.org/source/)         
Zlib [Link](https://zlib.net/)       
pcre [Link](https://ftp.pcre.org/pub/pcre/)         
### 编译安装脚本           
Linux 一键编译安装脚本 [查看源文件](/storage/linux/scripts/nginx/make_nginx1.26x.sh)     
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/make_nginx1.26x.sh
sudo chmod +x ./make_nginx1.26x.sh
sudo ./make_nginx1.26x.sh
```
Linux 一键编译二进制文件 [查看源文件](/storage/linux/scripts/nginx/deploy_nginx1.26x.sh)     
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/deploy_nginx1.26x.sh
sudo chmod +x ./deploy_nginx1.26x.sh
sudo ./deploy_nginx1.26x.sh
```       
一键安装 Nginx 1.28.x [查看源文件](/storage/linux/scripts/nginx/install_nginx1.28x.sh)         
```sh
sudo wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/install_nginx1.28x.sh
sudo chmod +x ./install_nginx1.28x.sh
sudo ./install_nginx1.28x.sh --amd64
```
```sh
sudo sed -i 's/phpmyadmin/pma/g' /etc/nginx/conf.d/phpmyadmin.conf
sudo cat /etc/nginx/conf.d/phpmyadmin.conf
```
重新启动 nginx       
```sh
sudo systemctl enable nginx
sudo systemctl stop nginx
sudo systemctl start nginx
sudo systemctl status nginx
```   
强制 SSL 网页跳转 [source file](/storage/linux/scripts/nginx/conf.d/default_force.conf)                         
```sh
sudo wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/default_force.conf
sudo mkdir -p /var/www/html

domain=test.com
sudo sed -i "s/example.com/${domain}/g" /etc/nginx/conf.d/default.conf

sudo mkdir -p /etc/letsencrypt/live/$domain
sudo vim /etc/letsencrypt/live/$domain/fullchain.pem
sudo vim /etc/letsencrypt/live/$domain/privkey.pem
```
安装 Let's Encrypt 证书, 证书路径 `~/.acme.sh/`            
```sh
sudo wget -O -  https://get.acme.sh | sh

source ~/.bashrc

sudo systemctl stop nginx
acme.sh --issue --standalone -d example.com -d www.example.com -d cp.example.com
```
非 80、443 端口，安卓 Let's Encrypt 证书，可以使用 DNS 验证的方式, cloudflare 界面添加 txt 记录。           
```sh
sudo rm -rf /etc/letsencrypt/live
sudo mkdir -p /etc/letsencrypt/live && cd /etc/letsencrypt/live
sudo apt install certbot
sudo certbot certonly --manual --preferred-challenges dns -d example.com --register-unsafely-without-email
```
PHP-FPM [source](/storage/linux/scripts/nginx/conf.d/nginx-ssl-fpm.conf)                
```sh
sudo wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/nginx-ssl-fpm.conf

domain=test.com
sudo sed -i "s/example.com/${domain}/g" /etc/nginx/conf.d/default.conf

sudo mkdir -p /etc/letsencrypt/live/$domain
sudo vim /etc/letsencrypt/live/$domain/fullchain.pem
sudo vim /etc/letsencrypt/live/$domain/privkey.pem
```
### cdnjs         
nginx 配置文件 [source](/storage/linux/scripts/nginx/conf.d/cdnjs.conf)           
```sh
sudo wget -O /etc/nginx/conf.d/cdnjs.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/cdnjs.conf
```
一键构建 cdnjs [source](/storage/linux/scripts/cdnjs/deploy.sh)          
```sh
sudo wget -O deploy_cdnjs.sh https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/cdnjs/deploy.sh
sudo chmod +x ./deploy_cdnjs.sh
sudo ./deploy_cdnjs.sh
```