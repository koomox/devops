#!/bin/bash

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
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
}

function install_ffsend() {
	bit=$(uname -m)
	if ! `command -v ffsend >/dev/null`; then
		if [[ ${bit} == "x86_64" ]]; then
			wget https://github.com/timvisee/ffsend/releases/download/v0.2.38/ffsend-v0.2.38-linux-x64-static -O /usr/local/bin/ffsend
			chmod +x /usr/local/bin/ffsend
		elif [[ ${bit} == "i386" || ${bit} == "i686" ]]; then
			bit="386"
		elif [[ ${bit} =~ "arm" ]]; then
			bit="armv6l"
		fi
	fi
}

function ffsend_upload() {
	fileName=$1
	if `command -v ffsend >/dev/null`; then
		ffsend upload ${fileName}
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

function compressFunc() {
	compressPath=$1
	compressName=$2
	cd ${compressPath}
	if [ -f ${compressName}.tar.gz ]; then
		\rm -rf ${compressName}.tar.gz
	fi
	tar -zcvf ${compressName}.tar.gz ${compressName}
}

installation_dependency
install_ffsend
DeployDirFunc /tmp/make_firefoxsend

downloadFunc ${NGINX_FULL_NAME} ${NGINX_DOWNLOAD_LINK}
downloadFunc ${OPENSSL_FULL_NAME} ${OPENSSL_DOWNLOAD_LINK}
downloadFunc ${ZLIB_FULL_NAME} ${ZLIB_DOWNLOAD_LINK}
downloadFunc ${PCRE_FULL_NAME} ${PCRE_DOWNLOAD_LINK}

compressFunc /tmp make_firefoxsend
ffsend_upload /tmp/make_firefoxsend.tar.gz

https://github.com/mozilla/send.git