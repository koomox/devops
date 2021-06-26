# Alpine Linux for LEMP             
### Nginx           
安装 Nginx        
```sh
apk update
apk add --no-cache nginx
```
启动 Nginx, 并设置为开机自启动           
```sh
rc-service nginx start
rc-update add nginx
ps aux | grep nginx
```
查看 nginx 错误日志           
```sh
tail -f /var/log/nginx/error.log
tail -f /var/log/nginx/access.log
```
### PHP          
安装 PHP        
```sh
apk add --no-cache php7-fpm php7-mcrypt php7-soap php7-openssl php7-gmp php7-pdo_odbc php7-json php7-dom php7-pdo php7-zip php7-mysqli php7-sqlite3 php7-apcu php7-pdo_pgsql php7-bcmath php7-gd php7-odbc php7-pdo_mysql php7-pdo_sqlite php7-gettext php7-xmlreader php7-xmlrpc php7-bz2 php7-iconv php7-pdo_dblib php7-curl php7-ctype
```
设置环境变量          
```sh
PHP_FPM_USER="www"
PHP_FPM_GROUP="www"
PHP_FPM_LISTEN_MODE="0660"
PHP_MEMORY_LIMIT="512M"
PHP_MAX_UPLOAD="50M"
PHP_MAX_FILE_UPLOAD="200"
PHP_MAX_POST="100M"
PHP_DISPLAY_ERRORS="On"
PHP_DISPLAY_STARTUP_ERRORS="On"
PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
PHP_CGI_FIX_PATHINFO=0
```
配置 `www.conf` 文件          
```sh
sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php7/php-fpm.d/www.conf
sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php7/php-fpm.d/www.conf #uncommenting line 
```
去掉 `;` 注释行和空行           
```sh
cd /etc/php7/php-fpm.d
\cp -f www.conf www.conf.bak
grep -v "^;" www.conf.bak | grep -v "^$" > www.conf

cat www.conf
```
配置 `php.ini`         
```sh
sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php7/php.ini
sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php7/php.ini
sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php7/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php7/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php7/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php7/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php7/php.ini
```
```sh
vim /etc/php7/php-fpm.conf
vim /etc/php7/php.ini
```
启动 php, 并设置为开机自启动           
```sh
rc-service php-fpm7 start
rc-update add php-fpm7
ps aux | grep 'php-fpm'
```
### MariaDB         
```sh
apk add --no-cache mariadb mariadb-client
```
```sh
DB_DATA_PATH="/var/lib/mysql"
DB_ROOT_PASS="mariadb_root_password"
DB_USER="mariadb_user"
DB_PASS="mariadb_user_password"
MAX_ALLOWED_PACKET="200M"
```
```sh
mysql_install_db --user=mysql --datadir=${DB_DATA_PATH}
```
```sh
rc-service mariadb start
rc-update add mariadb
ps aux | grep mysql
```
修改配置文件 `/etc/my.cnf` 替换为如下内容       
```ini
[client-server]
port=3306

[mysqld]
bind-address=127.0.0.1
port=3306
datadir=/var/lib/mysql
```
### Redis   
```sh
apk update
apk add --no-cache redis
```