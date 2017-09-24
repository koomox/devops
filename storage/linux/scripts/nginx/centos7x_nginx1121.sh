#!/bin/bash
mkdir -p /tmp/make_nginx
cd /tmp/make_nginx
\rm -rf *
yum -y install gcc gcc-c++ make perl curl

curl -LO http://nginx.org/download/nginx-1.12.1.tar.gz
curl -LO https://www.openssl.org/source/openssl-1.1.0f.tar.gz
curl -LO https://zlib.net/zlib-1.2.11.tar.gz
curl -LO https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.gz

tar -zxf openssl-1.1.0f.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.41.tar.gz
tar -zxf nginx-1.12.1.tar.gz

cd nginx-1.12.1
./configure --prefix=/usr/local/nginx \
--conf-path=/etc/nginx/nginx.conf \
--with-http_sub_module \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_gzip_static_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-pcre=../pcre-8.41 \
--with-zlib=../zlib-1.2.11 \
--with-openssl=../openssl-1.1.0f
make
make install

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile