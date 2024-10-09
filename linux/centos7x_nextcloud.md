# CentOS 7.x 安装 NextCloud             
NextCloud： [传送门](https://nextcloud.com/)              
NextCloud 下载地址: [传送门](https://download.nextcloud.com/)               
NextCloud Server for github.com: [传送门](https://github.com/nextcloud/server)             
NextCloud 13 Server for Nginx Configuration: [传送门](https://docs.nextcloud.com/server/13/admin_manual/installation/nginx.html)                
App Store for NextCloud: [传送门](https://apps.nextcloud.com/)           
### 添加用户、组            
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
nextcloud 推荐直接解压或移动到web根目录。复制会导致 `.htaccess`、`.user.ini` 文件丢失，出现文件不完整的错误。
```sh
curl -LO https://download.nextcloud.com/server/releases/nextcloud-13.0.5.tar.bz2
curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/nextcloud/nextcloud-13.0.5.tar.bz2
tar -jxf nextcloud-13.0.5.tar.bz2 -C /web
```
权限设置          
```sh
chmod -R 755 /web/nextcloud
chown -R php-fpm:www-data /web/nextcloud
```
nginx 配置文件 [点击查看源文件](../storage/linux/scripts/nextcloud/13.x/nginx-nextcloud.conf)           
```sh
curl -LO https://gitee.com/koomox/devops/raw/master/storage/linux/scripts/nextcloud/13.x/nginx-nextcloud.conf
\cp -f nginx-nextcloud.conf /etc/nginx/conf.d
```
创建 MySQL 数据库        
```sql
create database nextcloud character set utf8 collate utf8_general_ci;
grant all privileges on nextcloud.* to 'nextcloud'@'%' identified by 'c2t7oe56OgoiBit2YcqH';
grant all privileges on nextcloud.* to 'nextcloud'@'localhost' identified by 'c2t7oe56OgoiBit2YcqH';
flush privileges;
```
### 常见错误           
NextCloud 需要 PHP 的组件 fileinfo 模块支持。而安装 fileinfo 模块，需要安装 file-devel 依赖包。         
```sh
yum install file-devel
```
