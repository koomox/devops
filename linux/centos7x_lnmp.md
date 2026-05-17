# CentOS 7.x for LNMP               
### 用户管理          
创建 php-fpm、nginx、www-data 三个用户、组          
```sh
groupadd php-fpm
useradd -r -g php-fpm -s /bin/false php-fpm

groupadd nginx
useradd -r -g nginx -s /bin/false nginx

groupadd www-data
useradd -r -g www-data -s /bin/false www-data
```
将 php-fpm、nginx 添加到 www-data 用户组         
```sh
usermod -a -G www-data php-fpm
usermod -a -G www-data nginx
```
### MariaDB          
```
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/MariaDB/centos7x_mariadb1037.sh
chmod +x ./centos7x_mariadb1037.sh
./centos7x_mariadb1037.sh
```
设置 root 密码            
```
/usr/bin/mysql_secure_installation
```
### PHP              
下载 PHP 相关文件打包并上传至 firefox send               
```
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/download_php733.sh
chmod +x ./download_php733.sh
./download_php733.sh
```
```
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/centos7x_phpfpm727.sh
chmod +x ./centos7x_phpfpm727.sh
./centos7x_phpfpm727.sh
```
```
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/centos7x_php726.sh
chmod +x ./centos7x_php726.sh
./centos7x_php726.sh
```
```
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/centos7x_php724.sh
chmod +x ./centos7x_php724.sh
./centos7x_php724.sh
```
编译安装 php-7.2.7 的时候提示错误 `configure: error: off_t undefined; check your library configuration`          
```sh
echo '/usr/local/lib64
/usr/local/lib
/usr/lib
/usr/lib64' >> /etc/ld.so.conf && ldconfig -v
```
yum 在线安装 php7         
```
curl -LO https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
curl -LO http://rpms.remirepo.net/enterprise/remi-release-7.rpm

yum localinstall epel-release-latest-7.noarch.rpm -y
yum localinstall remi-release-7.rpm -y

curl -o /etc/yum.repos.d/remi.repo -L https://rpms.remirepo.net/enterprise/remi.repo

yum install yum-utils -y

yum-config-manager --enable remi-php72

yum install php php-fpm php-common php-cli php-json php-mcrypt php-gd php-zip php-opcache php-pdo php-mysqlnd -y

php -v
```
```
vim /etc/php-fpm.d/www.conf
```
去掉 `;` 注释行和空行            
```
cd /etc/php-fpm.d
\cp -f www.conf www-default.conf
grep -v "^;" www-default.conf | grep -v "^$" > www.conf

cat www.conf
```
```
systemctl enable php-fpm
systemctl start php-fpm
```
### Nginx   
```
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/centos7x_nginx1140.sh
chmod +x ./centos7x_nginx1140.sh
./centos7x_nginx1140.sh
```
```
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/centos7x_nginx1140.sh
chmod +x ./centos7x_nginx1140.sh
./centos7x_nginx1140.sh
```
配置http、ssl网站配置文件                
```
cd /etc/nginx/conf.d
\cp -f nginx-http-php.conf *.com.conf
\cp -f nginx-ssl-php.conf *.com.conf
```
把配置为配置文件添加到 nginx.conf 配置文件              
```
vim /etc/nginx/nginx.conf
```
### 日志          
```
tail -f /var/log/php/php-fpm.log
```
```
tail -f /var/log/nginx/error.log
```
```
tail -f /var/log/mariadb/mariadb.log
```
```
tail -f /var/log/messages
```
### Nginx 配置 301 强制跳转 HTTPS 后，一直显示 "此网页包含重定向循环"         
经过检查，是因为配置了 cloudflare 的 CDN 加速导致的，关闭后 cloudflare 的CDN功能后恢复正常。             

### 设置 404 页面          
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/404/404.html
chmod 755 ./404.html
```
可爱北极熊 404 页面            
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/404/bear-404.html
bear-404.html 404.html
chmod 755 ./404.html
```
404 页面            
```sh
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/404/worker-404.html
bear-404.html 404.html
chmod 755 ./404.html
```