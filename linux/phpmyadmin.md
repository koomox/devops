# phpMyAdmin       
Home: [Link](https://www.phpmyadmin.net/downloads/)             
### 部署 phpMyAdmin           
```sh
wget https://files.phpmyadmin.net/phpMyAdmin/4.9.1/phpMyAdmin-4.9.1-all-languages.tar.xz

\rm -rf /web/phpMyAdmin
mkdir -p /web/phpMyAdmin
xz -d phpMyAdmin-4.9.1-all-languages.tar.xz
tar --strip-components 1 -C /web/phpMyAdmin -xf phpMyAdmin-4.9.1-all-languages.tar

cp /web/phpMyAdmin/config.sample.inc.php /web/phpMyAdmin/config.inc.php

secret=`openssl rand -base64 50  | tr -dc A-Z-a-z-0-9 | head -c${1:-32}`
sed -ri "s/cfg\['blowfish_secret'\] = '.*'/cfg['blowfish_secret'] = '${secret}'/" /web/phpMyAdmin/config.inc.php
grep -E "^*blowfish_secret" /web/phpMyAdmin/config.inc.php
```
打开 `config.inc.php` 文件并编译。找到 `config.inc.php` 文件中的如下两行，`blowfish_secret` 为绝密的短语密码。              
```php
/**
 * This is needed for cookie based authentication to encrypt password in
 * cookie. Needs to be 32 chars long.
 */
$cfg['blowfish_secret'] = ''; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
```
找到 config.inc.php 文件中的如上内容，并修改为如下的内容保存。           
```php
$cfg['blowfish_secret'] = 'M6XmCrYlOULgoC3NckRAJyezH3BTbZRs';
```
使用 `openssl` 生成32位随机字符串          
```sh
echo `openssl rand -base64 50  | tr -dc A-Z-a-z-0-9 | head -c${1:-32}`
```
导入数据库         
```sh
mysql -uroot -p < /web/phpMyAdmin/sql/create_tables.sql
```
权限        
```sh
chmod -R 750 /web/phpMyAdmin
chown -R www-data:www-data /web/phpMyAdmin
```
重新启动 nginx            
```sh
systemctl stop nginx
systemctl start nginx
systemctl status nginx
```