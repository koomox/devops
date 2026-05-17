#!/bin/bash
PHP_VERSION=7.3.3
CMAKE_VERSION=3.14.0
OPENSSL_VERSION=1.0.2r
ZLIB_VERSION=1.2.11
PCRE_VERSION=8.42
LIBICONV_VERSION=1.15
LIBZIP_VERSION=1.5.1
ICU4C_VERSION=63_1
ICU4C_VER=63.1


PHP_FILE_NAME=php-${PHP_VERSION}
CMAKE_FILE_NAME=cmake-${CMAKE_VERSION}
OPENSSL_FILE_NAME=openssl-${OPENSSL_VERSION}
ZLIB_FILE_NAME=zlib-${ZLIB_VERSION}
PCRE_FILE_NAME=pcre-${PCRE_VERSION}
LIBICONV_FILE_NAME=libiconv-${LIBICONV_VERSION}
LIBZIP_FILE_NAME=libzip-${LIBZIP_VERSION}
ICU4C_FILE_NAME=icu4c-${ICU4C_VERSION}-src

PHP_FULL_NAME=${PHP_FILE_NAME}.tar.xz
CMAKE_FULL_NAME=${CMAKE_FILE_NAME}.tar.gz
OPENSSL_FULL_NAME=${OPENSSL_FILE_NAME}.tar.gz
ZLIB_FULL_NAME=${ZLIB_FILE_NAME}.tar.gz
PCRE_FULL_NAME=${PCRE_FILE_NAME}.tar.gz
LIBICONV_FULL_NAME=${LIBICONV_FILE_NAME}.tar.gz
LIBZIP_FULL_NAME=${LIBZIP_FILE_NAME}.tar.xz
ICU4C_FULL_NAME=${ICU4C_FILE_NAME}.tgz

PHP_DOWNLOAD_LINK=https://secure.php.net/distributions/${PHP_FULL_NAME}
CMAKE_DOWNLOAD_LINK=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/${CMAKE_FULL_NAME}
OPENSSL_DOWNLOAD_LINK=https://www.openssl.org/source/${OPENSSL_FULL_NAME}
ZLIB_DOWNLOAD_LINK=http://www.zlib.net/${ZLIB_FULL_NAME}
PCRE_DOWNLOAD_LINK=https://ftp.pcre.org/pub/pcre/${PCRE_FULL_NAME}
LIBICONV_DOWNLOAD_LINK=http://ftp.gnu.org/gnu/libiconv/${LIBICONV_FULL_NAME}
LIBZIP_DOWNLOAD_LINK=https://libzip.org/download/${LIBZIP_FULL_NAME}
ICU4C_DOWNLOAD_LINK=http://download.icu-project.org/files/icu4c/${ICU4C_VER}/${ICU4C_FULL_NAME}

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

function deCompressFunc() {
	fileName=$1
	fullName=$2
	if [ -f ${fileName} ]; then
		\rm -rf ${fileName}
	fi
	if [[ "${fullName##*.}" == "gz" ]]; then
		tar -zxf ${fullName}
	elif [[ "${fullName##*.}" == "xz" ]]; then
		xz -d ${fullName}
		tar -xf ${fileName}.tar
	elif [[ "${fullName##*.}" == "tgz" ]]; then
		tar -xf ${fullName}
	fi
}

installation_dependency
install_ffsend
DeployDirFunc /tmp/make_phpfpm
downloadFunc ${PHP_FULL_NAME} ${PHP_DOWNLOAD_LINK}
downloadFunc ${CMAKE_FULL_NAME} ${CMAKE_DOWNLOAD_LINK}
downloadFunc ${OPENSSL_FULL_NAME} ${OPENSSL_DOWNLOAD_LINK}
downloadFunc ${ZLIB_FULL_NAME} ${ZLIB_DOWNLOAD_LINK}
downloadFunc ${PCRE_FULL_NAME} ${PCRE_DOWNLOAD_LINK}
downloadFunc ${LIBICONV_FULL_NAME} ${LIBICONV_DOWNLOAD_LINK}
downloadFunc ${LIBZIP_FULL_NAME} ${LIBZIP_DOWNLOAD_LINK}
downloadFunc ${ICU4C_FULL_NAME} ${ICU4C_DOWNLOAD_LINK}

compressFunc /tmp make_phpfpm
ffsend_upload /tmp/make_phpfpm.tar.gz