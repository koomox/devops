#!/bin/bash
if [ -d shadowsocks-go ]; then
	\rm -rf shadowsocks-go;
fi
if [ -f shadowsocks-go.tar.gz ]; then
	\rm -rf shadowsocks-go.tar.gz
fi

git clone https://github.com/shadowsocks/shadowsocks-go.git --depth=1
cd shadowsocks-go
mkdir -p ./src/github.com/shadowsocks/shadowsocks-go
mv shadowsocks ./src/github.com/shadowsocks/shadowsocks-go
mkdir -p ./src/github.com/aead/chacha20
git clone https://github.com/aead/chacha20.git ./src/github.com/aead/chacha20 --depth=1
mkdir -p ./src/golang.org/x/crypto
git clone https://github.com/golang/crypto.git ./src/golang.org/x/crypto --depth=1
\rm -rf ./.git ./src/golang.org/x/crypto/.git ./src/github.com/aead/chacha20.git
cd ..
tar -zcvf shadowsocks-go.tar.gz shadowsocks-go
ffsend upload shadowsocks-go.tar.gz