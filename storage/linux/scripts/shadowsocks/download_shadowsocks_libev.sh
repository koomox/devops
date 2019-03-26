#!/bin/bash
if [ -d shadowsocks-libev ]; then
	\rm -rf shadowsocks-libev;
fi
if [ -f shadowsocks-libev.tar.gz ]; then
	\rm -rf shadowsocks-libev.tar.gz
fi

git clone https://github.com/shadowsocks/shadowsocks-libev.git
cd shadowsocks-libev
git submodule update --init --recursive
cd ..
tar -zcvf shadowsocks-libev.tar.gz shadowsocks-libev
ffsend upload shadowsocks-libev.tar.gz