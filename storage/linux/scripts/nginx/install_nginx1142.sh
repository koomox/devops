#!/bin/bash
WORK_PATH=/tmp/make_nginx
WEB_PATH=/var/www/html
NGINX_LOG_PATH=/var/log/nginx
NGINX_PID_PATH=/var/lib/nginx
NGINX_CONF_PATH=/etc/nginx/conf.d
NGINX_LETSENCRYPT=/var/www/letsencrypt

NGINX_VERSION=1.14.2
OPENSSL_VERSION=1.0.2r
ZLIB_VERSION=1.2.11
PCRE_VERSION=8.42

NGINX_FILE_NAME=nginx-${NGINX_VERSION}
OPENSSL_FILE_NAME=openssl-${OPENSSL_VERSION}.
ZLIB_FILE_NAME=zlib-${ZLIB_VERSION}
PCRE_FILE_NAME=pcre-${PCRE_VERSION}

NGINX_FULL_NAME=${NGINX_FILE_NAME}.tar.gz
OPENSSL_FULL_NAME=${OPENSSL_FILE_NAME}.tar.gz
ZLIB_FULL_NAME=${ZLIB_FILE_NAME}.tar.gz
PCRE_FULL_NAME=${PCRE_FILE_NAME}.tar.gz

NGINX_DOWNLOAD_LINK=https://nginx.org/download/${NGINX_FULL_NAME}
OPENSSL_DOWNLOAD_LINK=https://www.openssl.org/source/${OPENSSL_FULL_NAME}
ZLIB_DOWNLOAD_LINK=http://www.zlib.net/${ZLIB_FULL_NAME}
PCRE_DOWNLOAD_LINK=https://ftp.pcre.org/pub/pcre/${PCRE_FULL_NAME}

function installation_dependency(){
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

	if ! `command -v wget >/dev/null`; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
			yum groupinstall "Development Tools" -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
			apt install build-essential -y
		fi
	fi
}

function DeployDirFunc() {
	makeDir=$1
	if [ -f ${makeDir} ]; then
		\rm -rf ${makeDir}
	fi
	if [ ! -d ${makeDir} ]; then
		mkdir -p ${makeDir}
	fi
	cd ${makeDir}
}

function downloadFunc() {
	fileName=$1
	downLink=$2
	if [ -f ${fileName} ]; then
		echo "Found file ${fileName} Already Exist!"
	else
		wget ${downLink}
	fi
}

function deCompressFunc() {
	fileName=$1
	if [ -e ${fileName} ]; then
		\rm -rf ${fileName}
	fi
	tar -zxf ${fileName}
}

installation_dependency
DeployDirFunc /tmp/make_nginx
downloadFunc ${NGINX_FULL_NAME} ${NGINX_DOWNLOAD_LINK}
downloadFunc ${OPENSSL_FULL_NAME} ${OPENSSL_DOWNLOAD_LINK}
downloadFunc ${ZLIB_FULL_NAME} ${ZLIB_DOWNLOAD_LINK}
downloadFunc ${PCRE_FULL_NAME} ${PCRE_DOWNLOAD_LINK}
deCompressFunc ${NGINX_FULL_NAME}
deCompressFunc ${OPENSSL_FULL_NAME}
deCompressFunc ${ZLIB_FULL_NAME}
deCompressFunc ${PCRE_FULL_NAME}

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
--with-pcre=../${PCRE_FILE_NAME} \
--with-zlib=../${ZLIB_FILE_NAME} \
--with-openssl=../${OPENSSL_FILE_NAME}
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
	if ! `grep -Eq "^${USERNAME}" /etc/group`; then
		groupadd -r ${USERNAME}
	else
		echo "${USERNAME} Group Already Exist!"
	fi

	if ! `grep -Eq "^${USERNAME}" /etc/passwd`; then
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