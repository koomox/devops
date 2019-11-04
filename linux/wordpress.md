# WordPress          
Home: [Link](https://wordpress.org/download/)         
Themes: [Link](https://wordpress.com/themes)          
Astra Starter Sites [Link](https://wordpress.org/plugins/astra-sites/)        
WooCommerce [Link](https://wordpress.org/plugins/woocommerce/)        
ThemeForest [Link](https://themeforest.net/)          
Theme Developer [Link](https://developer.wordpress.org/themes/)           
### 部署 wordpress        
```sh
wget https://wordpress.org/latest.tar.gz

mkdir -p /web
\rm -rf /web/wordpress
tar -zxf latest.tar.gz -C /web

cp /web/wordpress/wp-config-sample.php /web/wordpress/wp-config.php 
```
新建数据库用户               
```sql
CREATE USER 'wordpress'@'localhost' IDENTIFIED BY 'password';
UPDATE mysql.user SET plugin='mysql_native_password';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
删除数据库用户          
```sql
DROP USER 'wordpress'@'localhost';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
创建数据库        
```sql
CREATE DATABASE IF NOT EXISTS `wordpress` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
SHOW DATABASES;
```
删除删除库        
```sql
DROP DATABASE wordpress;
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