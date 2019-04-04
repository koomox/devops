#!/bin/bash
if [ -d shadowsocks-go ]; then
	\rm -rf shadowsocks-go;
fi
if [ -f shadowsocks-go.tar.gz ]; then
	\rm -rf shadowsocks-go.tar.gz
fi

mkdir shadowsocks-go
cd shadowsocks-go
go get -u -d github.com/shadowsocks/shadowsocks-go
cd ..
tar -zcvf shadowsocks-go.tar.gz shadowsocks-go
ffsend upload shadowsocks-go.tar.gz