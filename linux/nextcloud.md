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
CREATE USER 'nextcloud'@'%' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON *.* TO 'nextcloud'@'%';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
删除数据库用户          
```sql
DROP USER 'nextcloud'@'%';
FLUSH PRIVILEGES;
SELECT User, Host, Password, plugin FROM mysql.user;
```
创建数据库        
```sql
CREATE DATABASE IF NOT EXISTS `nextcloud` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
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
chmod -R 750 /web/nextcloud
chown -R www-data:www-data /web/nextcloud
chmod +x /web/nextcloud/occ
```