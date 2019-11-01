# NextCloud             
NextCloud： [Link](https://nextcloud.com/)              
NextCloud: [Download Link](https://download.nextcloud.com/)               
NextCloud Server for github.com: [Link](https://github.com/nextcloud/server)             
NextCloud 12 Server for Nginx Configuration: [Link](https://docs.nextcloud.com/server/12/admin_manual/installation/nginx.html)                
App Store for NextCloud: [Link](https://apps.nextcloud.com/)           
### 部署 NextCloud          
```sh
wget https://download.nextcloud.com/server/releases/nextcloud-17.0.0.tar.bz2

\rm -rf /web/nextcloud
tar -jxf nextcloud-17.0.0.tar.bz2 -C /web
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
GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'localhost';
SHOW DATABASES;
```
删除删除库        
```sql
DROP DATABASE nextcloud;
SHOW DATABASES;
```
权限        
```sh
mkdir -p /web/nextcloud/{data,custom_apps}
chmod -R 775 /web/nextcloud
chown -R www-data:www-data /web/nextcloud
chmod +x /web/nextcloud/occ
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
重新启动 nginx        
```sh
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```