#!/bin/bash
mkdir -p /tmp/ss
cd /tmp/ss
yum -y install gcc gcc-c++ make perl asciidoc xmlto curl

curl -LO http://www.zlib.net/zlib-1.2.11.tar.gz
curl -LO https://www.openssl.org/source/openssl-1.0.2l.tar.gz
curl -LO https://ftp.pcre.org/pub/pcre/pcre-8.41.tar.gz
curl -LO https://github.com/shadowsocks/shadowsocks-libev/archive/v2.5.2.tar.gz
curl -LO https://github.com/shadowsocks/shadowsocks-libev/releases/download/v3.1.0/shadowsocks-libev-3.1.0.tar.gz

tar -zxf zlib-1.2.11.tar.gz
tar -zxf openssl-1.0.2l.tar.gz
tar -zxf pcre-8.41.tar.gz
tar -zxf v2.5.2.tar.gz
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
#=========== install openssl ================
yum -y install perl zlib-devel
cd openssl-1.0.2l
\rm -rf /usr/local/openssl /usr/bin/openssl /usr/include/openssl
./config --openssldir=/usr/local/openssl shared zlib
make && make install

ln -s /usr/local/openssl/bin/openssl /usr/bin/openssl
ln -s /usr/local/openssl/include/openssl /usr/include/openssl

touch /etc/ld.so.conf.d/openssl.conf
echo "/usr/local/openssl/lib" > /etc/ld.so.conf.d/openssl.conf
ldconfig -v
openssl version -a

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

#============ install shadowsocks ====================
yum -y install asciidoc xmlto
cd shadowsocks-libev-2.5.2
\rm -rf /usr/local/shadowsocks-libev
./configure --prefix=/usr/local/shadowsocks-libev \
--with-pcre=/usr/local/pcre \
--with-zlib=/usr/local/zlib \
--with-zlib-include=/usr/local/zlib/include \
--with-zlib-lib=/usr/local/zlib/lib \
--with-crypto-library=openssl \
--with-openssl=/usr/local/openssl \
--with-openssl-include=/usr/local/openssl/include \
--with-openssl-lib=/usr/local/openssl/lib
make && make install

#=========== 
cd shadowsocks-libev-3.1.0

ldd /usr/local/shadowsocks-libev/bin/ss-server

echo "install shadowsocks-libev complete!"