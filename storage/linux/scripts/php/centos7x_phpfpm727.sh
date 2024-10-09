#!/bin/bash
WORK_PATH=/tmp/make_phpfpm
mkdir -p ${WORK_PATH}
cd ${WORK_PATH}
\rm -rf *
yum -y install gcc gcc-c++ make perl curl

yum -y install libxslt libxslt-devel libxml2 libxml2-devel \
 libmcrypt libmcrypt-devel gd gd-devel libcurl libcurl-devel systemd-devel \
 libacl libacl-devel bzip2 bzip2-devel gmp gmp-devel libwebp libwebp-devel \
 ncurses ncurses-devel mhash mhash-devel perl

yum -y remove libzip libzip-devel


curl -LO https://www.openssl.org/source/openssl-1.0.2o.tar.gz
curl -LO https://zlib.net/zlib-1.2.11.tar.gz
curl -LO https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz
curl -LO http://ftp.gnu.org/gnu/libiconv/libiconv-1.15.tar.gz
curl -LO https://libzip.org/download/libzip-1.5.1.tar.xz
curl -LO http://download.icu-project.org/files/icu4c/62.1/icu4c-62_1-src.tgz
curl -LO http://php.net/distributions/php-7.2.7.tar.xz
curl -LO http://pear.php.net/go-pear.phar
curl -LO https://cmake.org/files/v3.11/cmake-3.11.4.tar.gz

tar -zxf openssl-1.0.2o.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.42.tar.gz
tar -zxf libiconv-1.15.tar.gz
xz -d libzip-1.5.1.tar.xz
tar -xf libzip-1.5.1.tar
tar -xf icu4c-62_1-src.tgz
xz -d php-7.2.7.tar.xz
tar -xf php-7.2.7.tar
tar -zxf cmake-3.11.4.tar.gz

#========= User Manager ==============================
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

create_system_user php-fpm
create_system_user nginx
create_system_user www-data

usermod -a -G www-data php-fpm
usermod -a -G www-data nginx
#========= install cmake =======================
pushd cmake-3.11.4
./bootstrap
make
make install
popd
#========= install zlib =======================
pushd zlib-1.2.11
./configure
make
make install
popd
#========= install pcre =======================
pushd pcre-8.42
./configure --enable-utf8
make
make install
popd
#========= install libiconv =======================
pushd libiconv-1.15
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
pushd libzip-1.5.1
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
yum -y install perl
pushd openssl-1.0.2o
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

mkdir -p /etc/php/conf.d
mkdir -p /etc/php/php-fpm.d
mkdir -p /var/lib/php
mkdir -p /var/log/php

pushd php-7.2.7
./configure --prefix=/usr/local/php \
--sysconfdir=/etc/php \
--includedir=/usr/include \
--enable-fpm \
--with-fpm-user=php-fpm \
--with-fpm-group=php-fpm \
--with-fpm-systemd \
--with-fpm-acl \
--with-config-file-path=/etc/php \
--with-config-file-scan-dir=/etc/php/conf.d \
--with-libxml-dir \
--with-openssl \
--with-pcre-regex \
--with-pcre-jit \
--with-zlib \
--with-zlib-dir \
--enable-bcmath \
--with-bz2 \
--with-curl \
--enable-exif \
--disable-fileinfo \
--enable-ftp \
--with-openssl-dir \
--with-gd \
--with-webp-dir \
--with-jpeg-dir \
--with-png-dir \
--with-zlib-dir \
--with-xpm-dir \
--with-freetype-dir \
--enable-gd-jis-conv \
--with-gettext \
--with-gmp \
--with-mhash \
--enable-intl \
--with-icu-dir=/usr/local/libicu \
--enable-mbstring \
--with-mysqli=mysqlnd \
--with-mysql-sock=/var/lib/mysql/mysql.sock \
--enable-pcntl \
--with-pdo-mysql=mysqlnd \
--with-zlib-dir \
--disable-phar \
--enable-shmop \
--enable-soap \
--with-libxml-dir \
--enable-sockets \
--with-iconv-dir=/usr/local/libiconv \
--with-xsl \
--enable-zip \
--with-zlib-dir \
--with-pcre-dir \
--with-libzip \
--enable-mysqlnd \
--with-zlib-dir \
--without-pear
make
make install
\cp -f php.ini-development php.ini-production /etc/php
popd

pushd /etc/php
\cp -f php.ini-production php.ini
popd

touch /etc/ld.so.conf.d/php.conf
echo "/usr/local/php/lib" > /etc/ld.so.conf.d/php.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/php/bin:/usr/local/php/sbin' >> /etc/profile
source /etc/profile

curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/7.2.7/php-fpm.conf
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/7.2.7/php-fpm.d/www.conf
\cp -f php-fpm.conf /etc/php/php-fpm.conf
\cp -f www.conf /etc/php/php-fpm.d/www.conf

curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/7.2.7/php-fpm.service
\cp -f php-fpm.service /usr/lib/systemd/system/php-fpm.service

systemctl enable php-fpm
systemctl start php-fpm
systemctl status php-fpm

php-fpm -v
############### install phpmyadmin ################
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/libs/php/phpmyadmin/4.8.2/phpMyAdmin-4.8.2-all-languages.tar.xz
xz -d phpMyAdmin-4.8.2-all-languages.tar.xz
tar -xf phpMyAdmin-4.8.2-all-languages.tar
mv phpMyAdmin-4.8.2-all-languages /var/www/html/pma

curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/php/index.php
curl -LO https://raw.githubusercontent.com/koomox/devops/master/storage/linux/libs/php/phpmyadmin/4.8.2/config.inc.php
\cp -f index.php /var/www/html
\cp -f config.inc.php /var/www/html/pma
mkdir -p /var/www/html/pma/tmp
pushd /var/www/html
chmod -R 775 .
chown -R php-fpm:www-data .
chmod 777 /var/www/html/pma/tmp
popd