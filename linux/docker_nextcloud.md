# NextCloud             
NextCloud： [传送门](https://nextcloud.com/)              
NextCloud 下载地址: [传送门](https://download.nextcloud.com/)               
NextCloud Server for github.com: [传送门](https://github.com/nextcloud/server)             
NextCloud 12 Server for Nginx Configuration: [传送门](https://docs.nextcloud.com/server/12/admin_manual/installation/nginx.html)                
App Store for NextCloud: [传送门](https://apps.nextcloud.com/)           

### Docker             
Docker CE for github.com: [传送门](https://github.com/docker/docker-ce)                           
Docker CE for Ubuntu Install: [传送门](https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/)                           
Docker CE Stable 二进制包: [传送门](https://download.docker.com/linux/static/stable/x86_64/)             
Docker Compose for github.com: [传送门](https://github.com/docker/compose)                                

```sh
/rm -rf /docker/nextcloud
mkdir -p /docker/nextcloud/data
mkdir -p /docker/nextcloud/web
mkdir -p /docker/nextcloud/nginx/cert
wget -O /docker/nextcloud/docker-compose.yml https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/docker-compose.yml
wget -O /docker/nextcloud/nginx/nginx.conf https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/nginx-general.conf
```

### 添加用户、组            
```sh
groupadd mysql
useradd  -r -g mysql -s /bin/false mysql

groupadd www-data
useradd  -r -g www-data -s /bin/false www-data

groupadd nginx
useradd  -r -g nginx -s /bin/false nginx

usermod -a -G docker mysql
usermod -a -G docker www-data
usermod -a -G docker nginx

chmod 750 /docker/nextcloud/data
chown -R mysql:mysql /docker/nextcloud/data

chmod -R 777 /docker/nextcloud/web
chown -R www-data:www-data /docker/nextcloud/web
```

### 重置数据         
```sh
rm -rf /docker/nextcloud/data
rm -rf /docker/nextcloud/web
rm -rf /docker/nextcloud/docker-compose.yml
rm -rf /docker/nextcloud/nginx/nginx.conf
mkdir -p /docker/nextcloud/data
chmod 750 /docker/nextcloud/data
chown -R mysql:mysql /docker/nextcloud/data
mkdir -p /docker/nextcloud/web
chmod -R 777 /docker/nextcloud/web
chown -R www-data:www-data /docker/nextcloud/web
wget -O /docker/nextcloud/docker-compose.yml https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/docker-compose.yml
wget -O /docker/nextcloud/nginx/nginx.conf https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/nginx-general.conf
docker-compose up
```
重新设置 docker-compose.yml 配置文件              
```sh
rm -rf /docker/nextcloud/docker-compose.yml
wget -O /docker/nextcloud/docker-compose.yml https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/docker-compose.yml
docker-compose up
```
重新设置 nginx.conf 配置文件             
```sh
cd ./nginx
rm -rf nginx.conf
wget -O /docker/nextcloud/nginx/nginx.conf https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/nginx-general.conf
cd ..
```           
设置 nextcloud web 目录的权限                    
```sh
chmod -R 777 /docker/nextcloud/web
chown -R www-data:www-data /docker/nextcloud/web
```      
### docker-compose 配置文件         
docker-compose 的默认配置文件 docker-compose.yml [查看源文件](../storage/linux/scripts/docker/nextcloud/docker-compose.yml)               

nginx 配置文件nginx.conf [查看源文件](../storage/linux/scripts/docker/nextcloud/nginx-nextcloud.conf)           
 
## Docker 独立配置 MySQL、PHP、Nginx          
```sh
\rm -rf /docker/nextcloud /data/mysql
mkdir -p /docker/nextcloud/nginx/cert
mkdir -p /data/mysql
```
创建 MySQL 8.0 服务           
```sh
groupadd mysql
useradd -r -g mysql -s /bin/false mysql

usermod -a -G docker mysql

chmod 750 /data/mysql
chown -R mysql:docker /data/mysql
```
```sh
docker run \
--name mysql_server_80_db \
--restart=always \
-p 3306:3306 \
-v /data/mysql:/var/lib/mysql \
-e MYSQL_ROOT_PASSWORD=123456 \
-e MYSQL_PASSWORD=123456 \
-e MYSQL_DATABASE=nextcloud \
-e MYSQL_USER=nextcloud \
-d mysql:8.0
```
Make 一个适合于 NextCloud 的 Docker php-fpm 版本               
```sh
rm -rf /docker/builder/php/7.1-fpm/Dockerfile
wget -O /docker/builder/php/7.1-fpm/Dockerfile https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/7.1-fpm.Dockerfile
docker build -t koomox/php:7.1-fpm /docker/builder/php/7.1-fpm
```
创建 7.1-fpm 服务          
```sh
docker run \
--name phpfpm_7.1 \
--link mysql_server_80_db:db \
--restart=always \
-v /docker/nextcloud/nextcloud:/var/www/html \
-d koomox/php:7.1-fpm
```
```sh
wget -O /docker/nextcloud/nginx/nginx.conf https://git.oschina.net/koomox/devops/raw/master/storage/linux/scripts/docker/nextcloud/nginx-general.conf
wget -O /docker/nextcloud/nginx/cert/nextcloud.crt https://git.oschina.net/koomox/devops/raw/master/storage/certs/kox/nextcloud.crt
wget -O /docker/nextcloud/nginx/cert/nextcloud.key https://git.oschina.net/koomox/devops/raw/master/storage/certs/kox/nextcloud.key
```
创建 Nginx 1.12 服务              
```sh
groupadd nginx
useradd -r -g nginx -s /bin/false nginx
groupadd www-data
useradd -r -g www-data -s /bin/false www-data

usermod -a -G docker nginx
usermod -a -G docker www-data
usermod -a -G nginx www-data
```
```sh
cd /docker/nextcloud
\rm -rf nextcloud-12.0.2.tar.bz2

wget http://7xqxqz.com1.z0.glb.clouddn.com/nextcloud-12.0.2.tar.bz2

wget https://download.nextcloud.com/server/releases/nextcloud-12.0.2.tar.bz2
tar -jxf nextcloud-12.0.2.tar.bz2
mkdir -p /docker/nextcloud/nextcloud/data
mkdir -p /docker/nextcloud/nextcloud/custom_apps
chmod +x /docker/nextcloud/nextcloud/occ

chown -R www-data:www-data /docker/nextcloud/nextcloud
chmod -R 775 /docker/nextcloud/nextcloud
```
```sh
docker run \
--name nextcloud_app \
-p 80:80 \
-p 443:443 \
--link mysql_server_80_db:db \
--link phpfpm_7.1:php_fpm \
--restart=always \
-v /docker/nextcloud/nextcloud:/var/www/html \
-v /docker/nextcloud/nginx/nginx.conf:/etc/nginx/nginx.conf:ro \
-v /docker/nextcloud/nginx/cert/nextcloud.crt:/etc/nginx/cert/nextcloud.crt \
-v /docker/nextcloud/nginx/cert/nextcloud.key:/etc/nginx/cert/nextcloud.key \
-d nginx:1.12
```
```sh
cd /docker/nextcloud/nginx/cert
mv *.crt nextcloud.crt
mv *.key nextcloud.key
```