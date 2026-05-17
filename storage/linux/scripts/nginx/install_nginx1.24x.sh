#!/bin/bash
wget -O nginx-1.24.0.tar.gz https://github.com/koomox/nginx/releases/download/nginx-2023.4.23/nginx-1.24.0_debian-amd64.tar.gz
tar -zxf nginx-1.24.0.tar.gz
\rm -rf /usr/local/nginx /etc/nginx
mv nginx-1.24.0 /usr/local/nginx
cd /usr/local/nginx
mv conf /etc/nginx
cp -f nginx.service /etc/systemd/system/nginx.service

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile

mkdir -p /var/www/html /var/log/nginx /var/lib/nginx /var/www/letsencrypt /web/public /web/phpMyAdmin

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