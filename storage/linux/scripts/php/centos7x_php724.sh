#!/bin/bash
mkdir -p /tmp/make_phpfpm
cd /tmp/make_phpfpm
\rm -rf *
yum -y install gcc gcc-c++ make perl curl

yum -y install zlib-devel libxslt libxslt-devel libxml2 \
	libxml2-devel libmcrypt libmcrypt-devel gd gd-devel \
	libcurl libcurl-devel systemd-devel libacl libacl-devel \
	bzip2 bzip2-devel gmp gmp-devel libwebp libwebp-devel \
	ncurses ncurses-devel mhash mhash-devel

yum -y install libiconv libiconv-devel libzip libzip-devel libicu libicu-devel

curl -LO http://php.net/distributions/php-7.2.4.tar.xz
xz -d php-7.2.4.tar.xz
tar -xf php-7.2.4.tar
cd php-7.2.4
mkdir -p /etc/php/conf
./configure --prefix=/usr/local/php \
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
--with-bz2 \
--with-curl \
--enable-exif \
--disable-fileinfo \
--enable-ftp \
--with-openssl-dir \
--with-gd \
--with-webp-dir \
--with-jpeg-dir=/usr/lib64 \
--with-png-dir \
--with-zlib-dir \
--with-xpm-dir \
--with-freetype-dir \
--enable-gd-native-ttf \
--enable-gd-jis-conv \
--with-gettext \
--with-gmp \
--with-mhash \
--enable-intl \
--with-icu-dir=/usr/local/libicu \
--enable-mbstring \
--with-mcrypt \
--with-mysqli=mysqlnd \
--with-mysql-sock \
--enable-pcntl \
--with-pdo-mysql=mysqlnd \
--with-zlib-dir \
--disable-phar \
--enable-shmop \
--enable-soap \
--with-libxml-dir \
--enable-sockets \
--with-iconv-dir \
--with-xsl \
--enable-zip \
--with-zlib-dir \
--with-pcre-dir \
--with-libzip=/usr/local/libzip \
--enable-mysqlnd \
--with-zlib-dir \
--without-pear
make
make install