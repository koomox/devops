# WordPress          
Home: [Link](https://wordpress.org/download/)         
Themes: [Link](https://wordpress.com/themes)          
Astra Starter Sites [Link](https://wordpress.org/plugins/astra-sites/)        
WooCommerce [Link](https://wordpress.org/plugins/woocommerce/)        
WooCommerce Admin [Link](https://wordpress.org/plugins/woocommerce-admin/)        
WooCommerce Services [Link](https://wordpress.org/plugins/woocommerce-services/)        
WooCommerce Docs [Link](https://docs.woocommerce.com/)          
Storefront Theme [Link](https://wordpress.org/themes/storefront/)        
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
### permalinks          
wordpress 设置 permalinks 为 post name, 需要配置 nginx, 添加如下内容           
```ini
location / {
    try_files $uri $uri/ /index.php?$args;
}
```
下载 nginx 配置文件           
```sh
wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.1/conf.d/ssl_php_fpm_cdnjs_wordpress.conf

domain=example.com
sed -i "s/example.com/${domain}/g" /etc/nginx/conf.d/default.conf
```
### WooCommerce          
手动安装 WooCommerce，需要下载 WooCommerce、 WooCommerce Admin、 WooCommerce Services, 安装得 Theme 需要支持 WooCommerce，所以安装 Storefront Theme。           
如果要创建基于 WooCommerce Theme，那么需要创建基于 Storefront Theme 得 Child Theme。         