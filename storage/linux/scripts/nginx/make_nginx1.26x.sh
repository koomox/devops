#!/bin/bash
NGINX_VERSION=NGINX=$(wget -qO- --no-check-certificate https://nginx.org/en/download.html | grep -m1 -E "nginx-1.26.([0-9]+).tar.gz" | sed -E "s/.*(nginx-1.26.[0-9]+).tar.gz.*/\1/gm" )
OPENSSL_VERSION=$(wget -qO- --no-check-certificate https://www.openssl-library.org/source/ | grep -m1 -E "openssl-3(\.[0-9]+){0,2}.tar.gz" | sed -E "s/.*(openssl-.*).tar.gz.*/\1/gm" )
PCRE2_VERSION=pcre2-10.44
ZLIB_VERSION=$(wget -qO- --no-check-certificate https://zlib.net/ | grep -m1 -E "zlib-([0-9]+\.){0,3}tar.gz" | sed -E "s/.*(zlib-.*).tar.gz.*/\1/gm" )

if [ ! -d make_nginx ]; then
	\rm -rf make_nginx
fi
mkdir -p make_nginx && cd make_nginx

wget https://nginx.org/download/${NGINX_VERSION}.tar.gz
wget https://github.com/openssl/openssl/releases/download/${OPENSSL_VERSION}/${OPENSSL_VERSION}.tar.gz
wget https://github.com/PCRE2Project/pcre2/releases/download/${PCRE2_VERSION}/${PCRE2_VERSION}.tar.gz
wget https://www.zlib.net/${ZLIB_VERSION}.tar.gz

tar -zxf ${OPENSSL_VERSION}.tar.gz
tar -zxf ${PCRE2_VERSION}.tar.gz
tar -zxf ${ZLIB_VERSION}.tar.gz
tar -zxf ${NGINX_VERSION}.tar.gz

cd ${NGINX_VERSION}
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
--with-pcre=../${PCRE2_VERSION} \
--with-zlib=../${ZLIB_VERSION} \
--with-openssl=../${OPENSSL_VERSION}
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