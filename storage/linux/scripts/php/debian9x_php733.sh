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
DeployDirFunc /tmp/make_phpfpm
downloadFunc ${PHP_FULL_NAME} ${PHP_DOWNLOAD_LINK}
downloadFunc ${CMAKE_FULL_NAME} ${CMAKE_DOWNLOAD_LINK}
downloadFunc ${OPENSSL_FULL_NAME} ${OPENSSL_DOWNLOAD_LINK}
downloadFunc ${ZLIB_FULL_NAME} ${ZLIB_DOWNLOAD_LINK}
downloadFunc ${PCRE_FULL_NAME} ${PCRE_DOWNLOAD_LINK}
downloadFunc ${LIBICONV_FULL_NAME} ${LIBICONV_DOWNLOAD_LINK}
downloadFunc ${LIBZIP_FULL_NAME} ${LIBZIP_DOWNLOAD_LINK}
downloadFunc ${ICU4C_FULL_NAME} ${ICU4C_DOWNLOAD_LINK}

deCompressFunc ${PHP_FILE_NAME} ${PHP_FULL_NAME}
deCompressFunc ${CMAKE_FILE_NAME} ${CMAKE_FULL_NAME}
deCompressFunc ${OPENSSL_FILE_NAME} ${OPENSSL_FULL_NAME}
deCompressFunc ${ZLIB_FILE_NAME} ${ZLIB_FULL_NAME}
deCompressFunc ${PCRE_FILE_NAME} ${PCRE_FULL_NAME}
deCompressFunc ${LIBICONV_FILE_NAME} ${LIBICONV_FULL_NAME}
deCompressFunc ${LIBZIP_FILE_NAME} ${LIBZIP_FULL_NAME}
deCompressFunc ${ICU4C_FILE_NAME} ${ICU4C_FULL_NAME}

#========= User Manager ==============================
create_system_user php-fpm
create_system_user nginx
create_system_user www-data
usermod -a -G www-data php-fpm
usermod -a -G www-data nginx
#========= install cmake =======================
pushd ${CMAKE_FILE_NAME}
./bootstrap
make
make install
popd
#========= install zlib =======================
pushd ${ZLIB_FILE_NAME}
./configure
make
make install
popd
#========= install pcre =======================
pushd ${PCRE_FILE_NAME}
./configure --enable-utf8
make
make install
popd
#========= install libiconv =======================
pushd ${LIBICONV_FILE_NAME}
./configure --prefix=/usr/local/libiconv
sed -i -e '/gets is a security/d' ./srclib/stdio.in.h
make
make install

echo "/usr/local/libiconv/lib" > /etc/ld.so.conf.d/libiconv.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/libiconv/bin' >> /etc/profile
source /etc/profile

popd
#========= install libzip =======================
pushd ${LIBZIP_FILE_NAME}
mkdir build
cd build
cmake ..
make
make install
popd
#========= install icu =======================
pushd icu/source
./configure --prefix=/usr/local/libicu
make
make install
touch /etc/ld.so.conf.d/libicu.conf
echo "/usr/local/libicu/lib" > /etc/ld.so.conf.d/libicu.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/libicu/sbin' >> /etc/profile
source /etc/profile
popd
#========= install openssl =======================
pushd ${OPENSSL_FILE_NAME}
\rm -rf /usr/local/openssl /usr/bin/openssl /usr/include/openssl
./config --openssldir=/usr/local/openssl shared zlib
make && make install

ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl

touch /etc/ld.so.conf.d/openssl.conf
echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf
ldconfig -v
openssl version -a

popd
#========= install php-fpm =======================