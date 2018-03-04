#!/bin/bash
mkdir -p /tmp/make_nginx
cd /tmp/make_nginx
\rm -rf *
yum -y install gcc gcc-c++ make perl curl

curl -LO https://storage.allen.com/nginx/nginx-1.12.2.tar.gz
curl -LO https://storage.allen.com/openssl/openssl-1.0.2n.tar.gz
curl -LO https://storage.allen.com/zlib/zlib-1.2.11.tar.gz
curl -LO https://storage.allen.com/pcre/pcre-8.41.tar.gz

tar -zxf nginx-1.12.2.tar.gz
tar -zxf openssl-1.0.2n.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.41.tar.gz

cd nginx-1.12.2
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
--with-pcre=../pcre-8.41 \
--with-zlib=../zlib-1.2.11 \
--with-openssl=../openssl-1.0.2n
make
make install

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile

#============== Run Nginx ================
touch /usr/lib/systemd/system/nginx.service
cat >>/usr/lib/systemd/system/nginx.service<<EOF
[Unit]
Description=nginx - high performance web server 
Documentation=http://nginx.org/en/docs/
After=network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -c /etc/nginx/nginx.conf
ExecStartPost=/bin/sleep 0.1
ExecStart=/usr/local/nginx/sbin/nginx -c /etc/nginx/nginx.conf
ExecReload=/usr/local/nginx/sbin/nginx -s reopen
ExecStop=/usr/local/nginx/sbin/nginx -s stop
PrivateTmp=true

[Install]
WantedBy=multi-user.target
EOF

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

nginx -v