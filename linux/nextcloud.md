# NextCloud             
NextCloud： [Link](https://nextcloud.com/)              
NextCloud: [Download Link](https://download.nextcloud.com/)               
NextCloud Server for github.com: [Link](https://github.com/nextcloud/server)             
NextCloud 12 Server for Nginx Configuration: [Link](https://docs.nextcloud.com/server/12/admin_manual/installation/nginx.html)                
App Store for NextCloud: [Link](https://apps.nextcloud.com/)           
### 部署 NextCloud          
```sh
wget https://download.nextcloud.com/server/releases/nextcloud-17.0.0.tar.bz2

mkdir -p /var/www
\rm -rf /var/www/nextcloud
tar -jxf nextcloud-17.0.0.tar.bz2 -C /var/www
```
新建数据库用户               
```sql
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'password';
UPDATE mysql.user SET plugin='mysql_native_password';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
删除数据库用户          
```sql
DROP USER 'nextcloud'@'localhost';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
创建数据库        
```sql
CREATE DATABASE IF NOT EXISTS `nextcloud` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost' WITH GRANT OPTION;
SHOW DATABASES;
```
删除删除库        
```sql
DROP DATABASE nextcloud;
SHOW DATABASES;
```
权限        
```sh
mkdir -p /var/www/nextcloud/{data,custom_apps}
chmod -R 775 /var/www/nextcloud
chown -R www-data:www-data /var/www/nextcloud
chmod +x /var/www/nextcloud/occ
```
配置 php-fpm           
```sh
sed -i '/pm =/cpm = dynamic' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/pm.max_children =/cpm.max_children = 120' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/pm.start_servers =/cpm.start_servers = 12' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/pm.min_spare_servers =/cpm.min_spare_servers = 6' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/pm.max_spare_servers =/cpm.max_spare_servers = 18' /etc/php/7.3/fpm/pool.d/www.conf

cat /etc/php/7.3/fpm/pool.d/www.conf
```
重新启动 php-fpm        
```sh
systemctl stop php7.3-fpm
systemctl start php7.3-fpm
systemctl status php7.3-fpm
```
配置 nginx        
Nextcloud in the webroot of nginx [source](/storage/linux/scripts/nextcloud/17.x/nginx-nextcloud.conf)        
Nextcloud in a subdir of nginx [source](/storage/linux/scripts/nextcloud/17.x/nginx-subdir-nextcloud.conf)           
```sh
wget -O /etc/nginx/conf.d/nextcloud.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nextcloud/17.x/nginx-nextcloud.conf
cp -f /etc/nginx/conf.d/nextcloud.conf /etc/nginx/conf.d/nextcloud.conf.bak

domain="example.com"
cert="/etc/ssl/nginx/cloud.example.com.crt"
key="/etc/ssl/nginx/cloud.example.com.key"
sed -ri "s/^(.*)(server 127.0.0.1)(.*)/\1#\2\3/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(server unix:|#server unix:)(.*)/\1server unix:\/run\/php\/php7.3-fpm.sock/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(server_name )(.*)/\1\2${domain}/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(ssl_certificate )(.*)/\1\2${cert}/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(ssl_certificate_key )(.*)/\1\2${key}/g" /etc/nginx/conf.d/nextcloud.conf

grep -E "^.*(server|server_name|ssl_certificate|ssl_certificate_key)( )(.*)" /etc/nginx/conf.d/nextcloud.conf
```
重新启动 nginx        
```sh
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```