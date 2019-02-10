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

installation_dependency(){
	if grep -Eqi "CentOS|Red Hat|RedHat" /etc/issue || grep -Eq "CentOS|Red Hat|RedHat" /etc/*-release || grep -Eqi "CentOS|Red Hat|RedHat" /proc/version; then
		release="CentOS"
	elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
		release="Debian"
	elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release || grep -Eqi "Fedora" /proc/version; then
		release="Fedora"
	elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release || grep -Eqi "Ubuntu" /proc/version; then
		release="Ubuntu"
	elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
		release="Raspbian"
	elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
		release="Aliyun"
	else
		release="unknown"
	fi

	if [ ! `command -v wget >/dev/null` ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
			yum groupinstall "Development Tools" -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
			apt install build-essential -y
		fi
	fi
}

installation_dependency

if [ -e /tmp/make_nginx ]; then
	\rm -rf /tmp/make_nginx
fi
mkdir -p /tmp/make_nginx
cd /tmp/make_nginx

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

if [ -e /etc/nginx/conf.d ]; then
	\rm -rf /etc/nginx/conf.d
fi

mkdir -p /etc/nginx/conf.d

wget -O /etc/nginx/conf.d/fastcgi_php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/fastcgi_php.conf
wget -O /etc/nginx/conf.d/letsencrypt.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/letsencrypt.conf
wget -O /etc/nginx/conf.d/nginx-http-php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-http-php.conf
wget -O /etc/nginx/conf.d/nginx-ssl-php.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-ssl-php.conf
wget -O /etc/nginx/nginx.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/nginx/1.14.0/nginx-default.conf

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