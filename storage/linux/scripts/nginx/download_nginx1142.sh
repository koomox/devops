#!/bin/bash
NGINX_VERSION="1.14.2"
OPENSSL_VERSION="1.0.2r"
ZLIB_VERSION="1.2.11"
PCRE_VERSION="8.42"

NGINX_FULL_NAME="nginx-${NGINX_VERSION}.tar.gz"
OPENSSL_FULL_NAME="openssl-${OPENSSL_VERSION}.tar.gz"
ZLIB_FULL_NAME="zlib-${ZLIB_VERSION}.tar.gz"
PCRE_FULL_NAME="pcre-${PCRE_VERSION}.tar.gz"

NGINX_DOWNLOAD_LINK="https://nginx.org/download/${NGINX_FULL_NAME}"
OPENSSL_DOWNLOAD_LINK="https://www.openssl.org/source/${OPENSSL_FULL_NAME}"
ZLIB_DOWNLOAD_LINK="http://www.zlib.net/${ZLIB_FULL_NAME}"
PCRE_DOWNLOAD_LINK="https://ftp.pcre.org/pub/pcre/${PCRE_FULL_NAME}"


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

	if [ `command -v wget >/dev/null` ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
	
	if [ `command -v ffsend >/dev/null` ]; then
		wget https://github.com/timvisee/ffsend/releases/download/v0.2.38/ffsend-v0.2.38-linux-x64-static -O /usr/local/bin/ffsend
		chmod +x /usr/local/bin/ffsend
	fi
}

DeployDirFunc() {
	makeDir=$1
	if [ -e ${makeDir} ]; then
		\rm -rf ${makeDir}
	fi
	if [ ! -d ${makeDir} ]; then
		mkdir -p ${makeDir}
	fi
	cd ${makeDir}
}

downloadFunc() {
	fileName=$1
	downLink=$2
	if [ ! -f ${fileName} ]; then
		echo "Found file ${fileName} Already Exist!"
	else
		wget ${downLink}
	fi
}

compressFunc() {
	compressPath=$1
	compressName=$2
	cd ${compressPath}
	if [ ! -e ${compressName}.tar.gz ]; then
		\rm -rf ${compressName}.tar.gz
	fi
	tar -zcvf ${compressName}.tar.gz ${compressName}
}

installation_dependency

DeployDirFunc /tmp/make_nginx

downloadFunc ${NGINX_FULL_NAME} ${NGINX_DOWNLOAD_LINK}
downloadFunc ${OPENSSL_FULL_NAME} ${OPENSSL_DOWNLOAD_LINK}
downloadFunc ${ZLIB_FULL_NAME} ${ZLIB_DOWNLOAD_LINK}
downloadFunc ${PCRE_FULL_NAME} ${PCRE_DOWNLOAD_LINK}

compressFunc /tmp make_nginx
ffsend upload /tmp/make_nginx.tar.gz