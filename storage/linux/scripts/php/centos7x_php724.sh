#!/bin/bash
WORK-PATH=/tmp/make_phpfpm
mkdir -p ${WORK-PATH}
cd ${WORK-PATH}
\rm -rf *
yum -y install gcc gcc-c++ make perl curl

yum -y install zlib zlib-devel libxslt libxslt-devel libxml2 libxml2-devel \
 libmcrypt libmcrypt-devel gd gd-devel libcurl libcurl-devel systemd-devel \
 libacl libacl-devel bzip2 bzip2-devel gmp gmp-devel libwebp libwebp-devel \
 ncurses ncurses-devel mhash mhash-devel perl zlib-devel

yum -y remove libzip libzip-devel

curl -LO https://www.openssl.org/source/openssl-1.0.2o.tar.gz
curl -LO https://zlib.net/zlib-1.2.11.tar.gz
curl -LO https://ftp.pcre.org/pub/pcre/pcre-8.42.tar.gz
curl -LO http://ftp.gnu.org/gnu/libiconv/libiconv-1.14.tar.gz
curl -LO https://nih.at/libzip/libzip-1.1.3.tar.gz
curl -LO http://download.icu-project.org/files/icu4c/58.2/icu4c-58_2-src.tgz
curl -LO http://php.net/distributions/php-7.2.6.tar.gz
curl -LO http://pear.php.net/go-pear.phar

tar -zxf openssl-1.0.2o.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.42.tar.gz
tar -zxf libiconv-1.14.tar.gz
tar -zxf libzip-1.1.3.tar.gz
tar -xf icu4c-58_2-src.tgz
tar -zxf php-7.2.6.tar.gz

#========= install libiconv =======================
cd libiconv-1.14
./configure --prefix=/usr/local/libiconv
sed -i -e '/gets is a security/d' ./srclib/stdio.in.h
make
make install

echo "/usr/local/libiconv/lib" > /etc/ld.so.conf.d/libiconv.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/libiconv/bin' >> /etc/profile
source /etc/profile

cd ${WORK-PATH}
#========= install libzip =======================
cd libzip-1.1.3
./configure --prefix=/usr/local/libzip
make
make install
\rm -rf /usr/local/libzip/include/zipconf.h
ln -s /usr/local/libzip/lib/libzip/include/zipconf.h /usr/local/libzip/include/zipconf.h
ln -s /usr/local/libzip/include/zip.h /usr/include/zip.h
ln -s /usr/local/libzip/lib/libzip/include/zipconf.h /usr/include/zipconf.h

touch /etc/ld.so.conf.d/libzip.conf
echo "/usr/local/libzip/lib" > /etc/ld.so.conf.d/libzip.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/libzip/bin' >> /etc/profile
source /etc/profile

cd ${WORK-PATH}
#========= install icu =======================
cd icu/source
./configure --prefix=/usr/local/libicu
make
make install
touch /etc/ld.so.conf.d/libicu.conf
echo "/usr/local/libicu/lib" > /etc/ld.so.conf.d/libicu.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/libicu/sbin' >> /etc/profile
source /etc/profile

cd ${WORK-PATH}
#========= install libzip =======================
yum -y install perl zlib-devel
cd openssl-1.0.2o
\rm -rf /usr/local/openssl /usr/bin/openssl /usr/include/openssl
./config --openssldir=/usr/local/openssl shared zlib
make && make install

ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl

touch /etc/ld.so.conf.d/openssl.conf
echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf
ldconfig -v
openssl version -a

cd ${WORK-PATH}
#========= install libzip =======================
groupadd php-fpm
useradd -g php-fpm php-fpm

cd php-7.2.6
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
--enable-gd-jis-conv \
--with-gettext \
--with-gmp \
--with-mhash \
--enable-intl \
--with-icu-dir=/usr/local/libicu \
--enable-mbstring \
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
--with-iconv-dir=/usr/local/libiconv \
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

\cp -f php.ini-development php.ini-production /etc/php
cd /etc/php
\cp -f php.ini-production php.ini

touch /etc/ld.so.conf.d/php.conf
echo "/usr/local/php/lib" > /etc/ld.so.conf.d/php.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/php/bin:/usr/local/php/sbin' >> /etc/profile
source /etc/profile

cd ${WORK-PATH}

mkdir -p /etc/php/php-fpm.d
mkdir -p /etc/php/conf.d
mkdir -p /var/log/php

curl -LO 
\cp -f /usr/local/php/etc/php-fpm.conf.default /etc/php/php-fpm.conf
\cp -f /usr/local/php/etc/php-fpm.d/www.conf.default /etc/php/php-fpm.d/www.conf

touch /usr/lib/systemd/system/php-fpm.service
cat >>/usr/lib/systemd/system/php-fpm.service<<EOF
[Unit]
Description=The PHP FastCGI Process Manager
After=syslog.target network.target

[Service]
Type=simple
PIDFile=/var/run/php/php-fpm.pid
ExecStart=/usr/local/php/sbin/php-fpm --nodaemonize --allow-to-run-as-root --fpm-config /etc/php/php-fpm.conf
ExecReload=/bin/kill -USR2 $MAINPID
ExecStop=/bin/kill -SIGINT $MAINPID

[Install]
WantedBy=multi-user.target
EOF

systemctl enable php-fpm