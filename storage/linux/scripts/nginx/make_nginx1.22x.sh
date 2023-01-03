#!/bin/bash
NGINX=nginx-1.22.1
OPENSSL=openssl-1.1.1s
PCRE=pcre-8.45
ZLIB=zlib-1.2.13

if [ ! -d make_nginx ]; then
	\rm -rf make_nginx
fi
mkdir -p make_nginx && cd make_nginx

wget https://nginx.org/download/${NGINX}.tar.gz
wget https://www.openssl.org/source/${OPENSSL}.tar.gz
wget https://ftp.exim.org/pub/pcre/${PCRE}.tar.gz
wget https://www.zlib.net/${ZLIB}.tar.gz

tar -zxf ${OPENSSL}.tar.gz
tar -zxf ${PCRE}.tar.gz
tar -zxf ${ZLIB}.tar.gz
tar -zxf ${NGINX}.tar.gz

cd ${NGINX}
./configure --prefix=/usr/local/nginx \
--conf-path=/etc/nginx/nginx.conf \
--pid-path=/var/lib/nginx/nginx.pid \
--lock-path=/var/lib/nginx/nginx.lock \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_gzip_static_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-stream \
--with-stream_ssl_module \
--with-pcre=../${PCRE} \
--with-zlib=../${ZLIB} \
--with-openssl=../${OPENSSL}
make
make install

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile

mkdir -p /etc/nginx/conf.d /var/www/html /var/log/nginx /var/lib/nginx /var/www/letsencrypt /web/public /web/phpMyAdmin

wget -O /etc/nginx/conf.d/fastcgi_php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/fastcgi_php.conf
wget -O /etc/nginx/conf.d/letsencrypt.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/letsencrypt.conf
wget -O /etc/nginx/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/default.conf
wget -O /etc/nginx/conf.d/nginx-ssl-fpm.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/nginx-ssl-fpm.conf
wget -O /etc/nginx/conf.d/phpmyadmin.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/phpmyadmin.conf
wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/nginx-default.conf

wget -O /etc/systemd/system/nginx.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/nginx.service

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