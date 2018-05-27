#!/bin/bash
WORK-PATH=/tmp/make_nginx
mkdir -p ${WORK-PATH}
cd ${WORK-PATH}
\rm -rf *
yum -y install gcc gcc-c++ make perl curl

curl -LO https://nginx.org/download/nginx-1.14.0.tar.gz
curl -LO https://www.openssl.org/source/openssl-1.0.2o.tar.gz
curl -LO https://zlib.net/zlib-1.2.11.tar.gz
curl -LO https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz

tar -zxf nginx-1.14.0.tar.gz
tar -zxf openssl-1.0.2o.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.42.tar.gz

cd nginx-1.14.0
./configure --prefix=/usr/local/nginx \
--conf-path=/etc/nginx/nginx.conf \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_sub_module \
--with-http_gzip_static_module \
--with-http_slice_module \
--with-http_stub_status_module \
--with-stream \
--with-stream_ssl_module \
--with-pcre=../pcre-8.42 \
--with-zlib=../zlib-1.2.11 \
--with-openssl=../openssl-1.0.2o
make
make install

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile

#============== Run Nginx ================
cd /usr/local/nginx
curl -LO https://github.com/koomox/devops/raw/master/storage/linux/scripts/nginx/1.14.0/nginx.service
\cp -f nginx.service /usr/lib/systemd/system/nginx.service

curl -LO https://github.com/koomox/devops/raw/master/storage/linux/scripts/nginx/1.14.0/nginx-php-fpm.conf
\cp -f nginx-php-fpm.conf /etc/nginx/nginx.conf

#=============== Enable Port =====================
#\cp -f /usr/lib/firewalld/services/http.xml /etc/firewalld/services/http.xml
#\cp -f /usr/lib/firewalld/services/https.xml /etc/firewalld/services/https.xml
#firewall-cmd --permanent --zone=public --add-service=http
#firewall-cmd --permanent --zone=public --add-service=https
#firewall-cmd --reload
#firewall-cmd --permanent --zone=public --query-service=http
#firewall-cmd --permanent --zone=public --query-service=https
#firewall-cmd --zone=public --list-all

#============= Start Nginx =======================
systemctl enable nginx
systemctl start nginx
systemctl status nginx

nginx -v