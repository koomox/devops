#!/bin/bash
WORK_PATH=/tmp/make_nginx
WEB_PATH=/var/www/html
NGINX_LOG_PATH=/var/log/nginx
NGINX_PID_PATH=/var/lib/nginx
NGINX_CONF_PATH=/etc/nginx/conf.d
NGINX_LETSENCRYPT=/var/www/letsencrypt
NGINX_VERSION=1.14.2
OPENSSL_VERSION=1.0.2q
ZLIB_VERSION=1.2.11
PCRE_VERSION=8.42

if [ -e /tmp/make_nginx ]; then
	\rm -rf /tmp/make_nginx
fi
mkdir -p /tmp/make_nginx
cd /tmp/make_nginx

apt install wget build-essential -y

wget https://ftp.pcre.org/pub/pcre/pcre-${PCRE_VERSION}.tar.gz
wget http://www.zlib.net/zlib-${ZLIB_VERSION}.tar.gz
wget https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
wget https://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz

tar -zxf pcre-${PCRE_VERSION}.tar.gz
tar -zxf zlib-${ZLIB_VERSION}.tar.gz
tar -zxf openssl-${OPENSSL_VERSION}.tar.gz
tar -zxf nginx-${NGINX_VERSION}.tar.gz

cd nginx-${NGINX_VERSION}
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
--with-pcre=../pcre-${PCRE_VERSION} \
--with-zlib=../zlib-${ZLIB_VERSION} \
--with-openssl=../openssl-${OPENSSL_VERSION}
make
make install

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile

#============== Run Nginx ================
cd /usr/local/nginx
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx.service
\cp -f nginx.service /etc/systemd/system/nginx.service

mkdir -p ${NGINX_CONF_PATH}
cd ${NGINX_CONF_PATH}
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/fastcgi_php.conf
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/letsencrypt.conf
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-http-php.conf
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-ssl-php.conf
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-default.conf

\cp -f nginx-default.conf ../nginx.conf

#============= Start Nginx =======================
mkdir -p ${NGINX_LOG_PATH}
mkdir -p ${NGINX_PID_PATH}
mkdir -p ${WEB_PATH}
mkdir -p ${NGINX_LETSENCRYPT}
chmod -R 755 ${WEB_PATH}
chmod -R 755 ${NGINX_LETSENCRYPT}

systemctl enable nginx
systemctl start nginx
systemctl status nginx

nginx -v