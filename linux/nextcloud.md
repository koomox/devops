# NextCloud             
NextCloud： [Link](https://nextcloud.com/)              
NextCloud: [Download Link](https://download.nextcloud.com/)               
NextCloud Server for github.com: [Link](https://github.com/nextcloud/server)             
NextCloud 12 Server for Nginx Configuration: [Link](https://docs.nextcloud.com/server/12/admin_manual/installation/nginx.html)                
App Store for NextCloud: [Link](https://apps.nextcloud.com/)           
### 部署 NextCloud          
```sh
wget https://download.nextcloud.com/server/releases/nextcloud-18.0.1.tar.bz2

mkdir -p /var/www
\rm -rf /var/www/nextcloud
tar -jxf nextcloud-18.0.1.tar.bz2 -C /var/www
```
新建数据库用户               
```sql
CREATE USER 'nextcloud'@'localhost' IDENTIFIED BY 'password';
UPDATE mysql.user SET plugin = 'mysql_native_password';
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
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost' IDENTIFIED BY 'nextcloud' WITH GRANT OPTION;
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
sed -i '/^pm.*/d' /etc/php/7.3/fpm/pool.d/www.conf
sed -i '/^env.*/d' /etc/php/7.3/fpm/pool.d/www.conf
echo -e "pm = dynamic\npm.max_children = 120\npm.start_servers = 12\npm.min_spare_servers = 6\npm.max_spare_servers = 18" >> /etc/php/7.3/fpm/pool.d/www.conf
echo -e "env[HOSTNAME] = \$HOSTNAME\nenv[PATH] = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin\nenv[TMP] = /tmp\nenv[TMPDIR] = /tmp\nenv[TEMP] = /tmp" >> /etc/php/7.3/fpm/pool.d/www.conf

cat /etc/php/7.3/fpm/pool.d/www.conf
```
配置 php.ini         
```ini
memory_limit = 128M
post_max_size = 16M
upload_max_filesize = 2M
```
```sh
sed -ri "s/^post_max_size()( = ).*/post_max_size = 10000M/g" /etc/php/7.3/fpm/php.ini
sed -ri "s/^upload_max_filesize()( = ).*/upload_max_filesize = 10000M/g" /etc/php/7.3/fpm/php.ini
sed -ri "s/^memory_limit()( = ).*/memory_limit = 512M/g" /etc/php/7.3/fpm/php.ini

grep -E "^(post_max_size|upload_max_filesize|memory_limit)( = ).*" /etc/php/7.3/fpm/php.ini
```
```sh
sed -ri "s/^(.*)opcache.enable=(.*)/opcache.enable=1/g" /etc/php/7.3/fpm/php.ini
sed -ri "s/^(.*)opcache.interned_strings_buffer=(.*)/opcache.interned_strings_buffer=8/g" /etc/php/7.3/fpm/php.ini
sed -ri "s/^(.*)opcache.max_accelerated_files=(.*)/opcache.max_accelerated_files=10000/g" /etc/php/7.3/fpm/php.ini
sed -ri "s/^(.*)opcache.memory_consumption=(.*)/opcache.memory_consumption=128/g" /etc/php/7.3/fpm/php.ini
sed -ri "s/^(.*)opcache.save_comments=(.*)/opcache.save_comments=1/g" /etc/php/7.3/fpm/php.ini

grep -E "^opcache\.(.*)" /etc/php/7.3/fpm/php.ini
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
cert="\/etc\/ssl\/nginx\/cloud.example.com.crt"
key="\/etc\/ssl\/nginx\/cloud.example.com.key"
sed -ri "s/^(.*)(server 127.0.0.1)(.*)/    #\2\3/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(server unix:)(.*)/    server unix:\/run\/php\/php7.3-fpm.sock;/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(server_name )(.*)/\1\2${domain};/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(ssl_certificate )(.*)/\1\2${cert};/g" /etc/nginx/conf.d/nextcloud.conf
sed -ri "s/^(.*)(ssl_certificate_key )(.*)/\1\2${key};/g" /etc/nginx/conf.d/nextcloud.conf

grep -E "^.*(server|server_name|ssl_certificate|ssl_certificate_key)( )(.*)" /etc/nginx/conf.d/nextcloud.conf
```
重新启动 nginx        
```sh
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```
### 配置 MariaDB         
配置 MariaDB 数据库，以支持 emoji, 打开 `/etc/mysql/mariadb.conf.d/50-server.cnf` 文件, mysqld 下面添加内容                  
```sh
vim /etc/mysql/mariadb.conf.d/50-server.cnf
```
```ini
[mysqld]
innodb_large_prefix=true
innodb_file_format=barracuda
innodb_file_per_table=1
```
设置 mariadb 文件格式为 `Barracuda`          
```sql
show variables like 'innodb_file_format';
SET GLOBAL innodb_file_format=Barracuda;
```
设置 nextcloud 数据库格式      
```sql
ALTER DATABASE nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
```
进入 nextcloud 目录转换文件格式          
```sh
cd /var/www/nextcloud

sudo -u www-data php occ config:system:set mysql.utf8mb4 --type boolean --value="true"
sudo -u www-data php occ maintenance:repair
```
进入数据库, 更改文件格式          
```sql
SELECT NAME, SPACE, FILE_FORMAT FROM INFORMATION_SCHEMA.INNODB_SYS_TABLES WHERE NAME like "nextcloud%";

USE INFORMATION_SCHEMA;
SELECT CONCAT("ALTER TABLE `", TABLE_SCHEMA,"`.`", TABLE_NAME, "` ROW_FORMAT=DYNAMIC;") AS MySQLCMD FROM TABLES WHERE TABLE_SCHEMA = "nextcloud";
```
重启数据库         
```sh
systemctl restart mariadb
```
### 访问 Nextcloud 经常出现 504 错误            
Nginx 配置文件添加下面的内容              
```sh
proxy_connect_timeout 600s;
proxy_send_timeout 600s;
proxy_read_timeout 600s;
fastcgi_send_timeout 600s;
fastcgi_read_timeout 600s;
```