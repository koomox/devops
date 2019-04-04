#!/bin/bash
if [ -d go-shadowsocks2 ]; then
	\rm -rf go-shadowsocks2;
fi
if [ -f go-shadowsocks2.tar.gz ]; then
	\rm -rf go-shadowsocks2.tar.gz
fi

mkdir go-shadowsocks2
cd go-shadowsocks2
go get -u -d github.com/shadowsocks/go-shadowsocks2
cd ..
tar -zcvf go-shadowsocks2.tar.gz go-shadowsocks2
ffsend upload go-shadowsocks2.tar.gz