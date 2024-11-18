#!/bin/bash
NGINX_VERSION=NGINX=$(wget -qO- --no-check-certificate https://nginx.org/en/download.html | grep -m1 -E "nginx-1.26.([0-9]+).tar.gz" | sed -E "s/.*(nginx-1.26.[0-9]+).tar.gz.*/\1/gm" )
OPENSSL_VERSION=$(wget -qO- --no-check-certificate https://www.openssl-library.org/source/ | grep -m1 -E "openssl-3(\.[0-9]+){0,2}.tar.gz" | sed -E "s/.*(openssl-.*).tar.gz.*/\1/gm" )
PCRE2_VERSION=pcre2-10.37
ZLIB_VERSION=$(wget -qO- --no-check-certificate https://zlib.net/ | grep -m1 -E "zlib-([0-9]+\.){0,3}tar.gz" | sed -E "s/.*(zlib-.*).tar.gz.*/\1/gm" )

if [ ! -d make_nginx ]; then
	\rm -rf make_nginx
fi
mkdir -p make_nginx && cd make_nginx
WORK_DIR=$(pwd)

wget https://nginx.org/download/${NGINX_VERSION}.tar.gz
wget https://github.com/openssl/openssl/releases/download/${OPENSSL_VERSION}/${OPENSSL_VERSION}.tar.gz
wget https://ftp.exim.org/pub/pcre/${PCRE2_VERSION}.tar.gz
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

mkdir -p ${WORK_DIR}/targets/${NGINX_VERSION}/{sbin,logs}
cd ${WORK_DIR}/${NGINX_VERSION}
cp objs/nginx ${WORK_DIR}/targets/${NGINX_VERSION}/sbin/nginx
cp -R html ${WORK_DIR}/targets/${NGINX_VERSION}
cp -R conf ${WORK_DIR}/targets/${NGINX_VERSION}

cd ${WORK_DIR}/targets/${NGINX_VERSION}/conf
cp mime.types mime.types.default
cp fastcgi_params fastcgi_params.default
cp fastcgi.conf fastcgi.conf.default
cp uwsgi_params uwsgi_params.default
cp scgi_params scgi_params.default
cp nginx.conf nginx.conf.default

wget -O ${WORK_DIR}/targets/${NGINX_VERSION}/nginx.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/nginx.service
wget -O ${WORK_DIR}/targets/${NGINX_VERSION}/conf/nginx.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/nginx-default.conf

mkdir -p ${WORK_DIR}/targets/${NGINX_VERSION}/conf/conf.d
wget -O ${WORK_DIR}/targets/${NGINX_VERSION}/conf/conf.d/default.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/default.conf
wget -O ${WORK_DIR}/targets/${NGINX_VERSION}/conf/conf.d/fastcgi_php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/fastcgi_php.conf
wget -O ${WORK_DIR}/targets/${NGINX_VERSION}/conf/conf.d/nginx-ssl-fpm.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/conf.d/nginx-ssl-fpm.conf

cd ${WORK_DIR}/targets
FILE_DATE=_$(date +"%Y%m%d%H%M")
tar czvf ${NGINX_VERSION}${FILE_DATE}.tar.gz ${NGINX_VERSION}
rm -rf ${NGINX_VERSION}