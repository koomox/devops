#!/bin/bash
WORK_PATH=/tmp/make_nginx
WEB_PATH=/var/www/html
NGINX_LOG_PATH=/var/log/nginx
NGINX_PID_PATH=/var/lib/nginx
NGINX_CONF_PATH=/etc/nginx/conf.d
NGINX_LETSENCRYPT=/var/www/letsencrypt
mkdir -p ${WORK_PATH}
cd ${WORK_PATH}
\rm -rf *
yum install curl -y
yum groupinstall "Development Tools" -y

curl -LO https://nginx.org/download/nginx-1.14.1.tar.gz
curl -LO https://www.openssl.org/source/openssl-1.0.2p.tar.gz
curl -LO https://zlib.net/zlib-1.2.11.tar.gz
curl -LO https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz

tar -zxf nginx-1.14.1.tar.gz
tar -zxf openssl-1.0.2p.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.42.tar.gz

cd nginx-1.14.1
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
--with-openssl=../openssl-1.0.2p
make
make install

echo 'export PATH=$PATH:/usr/local/nginx/sbin' >> /etc/profile
source /etc/profile

#============== Run Nginx ================
if [ -e /etc/nginx/conf.d ]; then
	\rm -rf /etc/nginx/conf.d
fi

mkdir -p /etc/nginx/conf.d

wget -O /etc/nginx/conf.d/fastcgi_php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/fastcgi_php.conf
wget -O /etc/nginx/conf.d/letsencrypt.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/letsencrypt.conf
wget -O /etc/nginx/conf.d/nginx-http-php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-http-php.conf
wget -O /etc/nginx/conf.d/nginx-ssl-php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-ssl-php.conf
wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-default.conf

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
mkdir -p ${NGINX_LOG_PATH}
mkdir -p ${NGINX_PID_PATH}
mkdir -p ${WEB_PATH}
mkdir -p ${NGINX_LETSENCRYPT}
chmod -R 755 ${WEB_PATH}
chmod -R 755 ${NGINX_LETSENCRYPT}

function create_system_user() {
	USERNAME=$1
	if ! `grep -Eq "^${USERNAME}" /etc/group` ; then
		groupadd -r ${USERNAME}
	else
		echo "${USERNAME} Group Already Exist!"
	fi

	if ! `grep -Eq "^${USERNAME}" /etc/passwd` ; then
		useradd -r -g ${USERNAME} -s /bin/false ${USERNAME}
	else
		echo "User ${USERNAME} Already Exist!"
	fi
}

init_nginx_service() {
	systemctl stop nginx
	systemctl disable nginx

	if [ -e /etc/systemd/system/nginx.service ]; then
		\rm -rf /etc/systemd/system/nginx.service
	fi

	if [ -e /lib/systemd/system/nginx.service ]; then
		\rm -rf /lib/systemd/system/nginx.service
	fi

	wget -O /etc/systemd/system/nginx.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx.service
	systemctl enable vlmcsd
	systemctl start vlmcsd
	systemctl status vlmcsd
}

create_system_user nginx
init_nginx_service

nginx -v