#!/bin/bash
if [ -d shadowsocks-libev ]; then
	\rm -rf shadowsocks-libev;
fi
if [ -f shadowsocks-libev.tar.gz ]; then
	\rm -rf shadowsocks-libev.tar.gz
fi
if [ -f libsodium-1.0.16.tar.gz ]; then
	\rm -rf libsodium-1.0.16.tar.gz
fi 
if [ -f mbedtls-2.6.0-gpl.tgz ]; then
	\rm -rf mbedtls-2.6.0-gpl.tgz
fi

git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
cd ..
wget https://download.libsodium.org/libsodium/releases/libsodium-1.0.16.tar.gz
wget https://tls.mbed.org/download/mbedtls-2.6.0-gpl.tgz
tar -zcvf shadowsocks-libev.tar.gz shadowsocks-libev
ffsend upload shadowsocks-libev.tar.gz