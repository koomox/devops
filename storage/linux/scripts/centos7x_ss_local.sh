#!/bin/bash
mkdir -p /tmp/ss
cd /tmp/ss
yum -y install gcc gcc-c++ make perl asciidoc xmlto curl

#curl -LO http://www.zlib.net/zlib-1.2.11.tar.gz
#curl -LO https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.gz
#curl -LO https://github.com/ARMmbed/mbedtls/archive/mbedtls-2.6.0.tar.gz
#curl -LO https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.1.0/shadowsocks-libev-3.1.0.tar.gz

tar -zxf zlib-1.2.11.tar.gz
tar -zxf pcre-8.41.tar.gz
tar -zxf mbedtls-2.6.0.tar.gz
tar -zxf shadowsocks-libev-3.1.0.tar.gz

#========= install zlib =======================
cd zlib-1.2.11
\rm -rf /usr/local/zlib
./configure --prefix=/usr/local/zlib
make && make install

touch /etc/ld.so.conf.d/zlib.conf
echo "/usr/local/zlib/lib" > /etc/ld.so.conf.d/zlib.conf

ldconfig -v

cd ..
#========= install pcre ================
cd pcre-8.41
\rm -rf /usr/local/pcre
./configure --prefix=/usr/local/pcre
make && make install

touch /etc/ld.so.conf.d/pcre.conf
echo "/usr/local/pcre/lib" > /etc/ld.so.conf.d/pcre.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/pcre/bin' >> /etc/profile
source /etc/profile

pcregrep -V

cd ..
#========= install mbedTLS ================
cd mbedtls-mbedtls-2.6.0
nl Makefile | sed -n '/DESTDIR=/p'
sed -i '/DESTDIR=\/usr\/local/c DESTDIR=\/usr\/local\/mbedtls' Makefile
nl Makefile | sed -n '/DESTDIR=/p'
make && make install

touch /etc/ld.so.conf.d/mbedtls.conf
echo "/usr/local/mbedtls/lib" > /etc/ld.so.conf.d/mbedtls.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/mbedtls/bin' >> /etc/profile
source /etc/profile

cd ..
#============ install shadowsocks ====================
yum install epel-release -y
#yum install gcc gettext autoconf libtool automake make pcre-devel asciidoc xmlto c-ares-devel libev-devel libsodium-devel mbedtls-devel -y
yum install gcc gettext autoconf libtool automake make asciidoc xmlto c-ares-devel libev-devel libsodium-devel -y
cd shadowsocks-libev-3.1.0
\rm -rf /usr/local/shadowsocks-libev
./configure --prefix=/usr/local/shadowsocks-libev \
--with-pcre=/usr/local/pcre \
--with-mbedtls=/usr/local/mbedtls \
--with-mbedtls-include=/usr/local/mbedtls/include \
--with-mbedtls-lib=/usr/local/mbedtls/lib

make && make install

mkdir -p /var/run/shadowsocks-libev
mkdir -p /etc/shadowsocks-libev

touch /etc/ld.so.conf.d/shadowsocks-libev.conf
echo "/usr/local/shadowsocks-libev/lib" > /etc/ld.so.conf.d/shadowsocks-libev.conf

ldconfig -v

echo 'export PATH=$PATH:/usr/local/shadowsocks-libev/bin' >> /etc/profile
source /etc/profile

cd ..
#===========

ldd /usr/local/shadowsocks-libev/bin/ss-server

echo "install shadowsocks-libev complete!"