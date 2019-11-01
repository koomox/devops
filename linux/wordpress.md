# WordPress          
Home: [Link](https://wordpress.org/download/)         
Themes: [Link](https://wordpress.com/themes)          
### 部署 wordpress        
```sh
wget https://wordpress.org/latest.tar.gz

mkdir -p /web
\rm -rf /web/wordpress /web/latest.tar.gz
tar -zxf latest.tar.gz -C /web

cp /web/wordpress/wp-config-sample.php /web/wordpress/wp-config.php 
```
新建数据库用户               
```sql
CREATE USER 'wordpress'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'wordpress'@'%';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
创建数据库        
```sql
CREATE DATABASE IF NOT EXISTS `wordpress` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
SHOW DATABASES;
```
权限        
```sh
chmod -R 750 /web/wordpress
chown -R www-data:www-data /web/wordpress
```
重新启动 nginx            
```sh
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```