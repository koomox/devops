#!/bin/bash
mkdir -p /usr/local/nginx/sbin
wget -O /usr/local/nginx/sbin/nginx https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/binary/nginx-1.16.1
chmod +x /usr/local/nginx/sbin/nginx

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile

mkdir -p /etc/nginx/conf.d /var/www/html /var/log/nginx /var/lib/nginx /var/www/letsencrypt /web/public /web/phpMyAdmin

wget -O /etc/nginx/conf.d/fastcgi_php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/fastcgi_php.conf
wget -O /etc/nginx/conf.d/letsencrypt.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/letsencrypt.conf
wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/conf.d/default.conf
wget -O /etc/nginx/conf.d/nginx-ssl-fpm.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/nginx-ssl-fpm.conf
wget -O /etc/nginx/conf.d/phpmyadmin.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/conf.d/phpmyadmin.conf
wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.16.0/nginx-default.conf

wget -O /etc/systemd/system/nginx.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx.service

groupadd php-fpm
useradd -r -g php-fpm -s /bin/false php-fpm

groupadd nginx
useradd -r -g nginx -s /bin/false nginx

groupadd www-data
useradd -r -g www-data -s /bin/false www-data

usermod -a -G www-data php-fpm
usermod -a -G www-data nginx

chmod -R 755 /etc/nginx/conf.d /var/www/html /var/log/nginx /var/lib/nginx /var/www/letsencrypt /web/public /web/phpMyAdmin
chown -R www-data:www-data /var/www/html /var/www/letsencrypt /web/public /web/phpMyAdmin

systemctl enable nginx
systemctl start nginx
systemctl status nginx

nginx -v