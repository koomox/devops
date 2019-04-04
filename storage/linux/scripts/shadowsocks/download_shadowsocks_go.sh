#!/bin/bash
if [ -d shadowsocks-go ]; then
	\rm -rf shadowsocks-go;
fi
if [ -f shadowsocks-go.tar.gz ]; then
	\rm -rf shadowsocks-go.tar.gz
fi

mkdir shadowsocks-go
cd shadowsocks-go
mkdir -p ./src/github.com/shadowsocks/shadowsocks-go
git clone https://github.com/shadowsocks/shadowsocks-go.git ./src/github.com/shadowsocks/shadowsocks-go --depth=1
mkdir -p ./src/github.com/aead/chacha20
git clone https://github.com/aead/chacha20.git ./src/github.com/aead/chacha20 --depth=1
mkdir -p ./src/golang.org/x/sys
git clone https://github.com/golang/sys.git ./src/golang.org/x/sys --depth=1
mkdir -p ./src/golang.org/x/crypto
git clone https://github.com/golang/crypto.git ./src/golang.org/x/crypto --depth=1

echo -e "export GOPATH=$(pwd)\ngo build -o ss-server github.com/shadowsocks/shadowsocks-go/cmd/shadowsocks-server\ngo build -o ss-local github.com/shadowsocks/shadowsocks-go/cmd/shadowsocks-local" > ./run.sh

find . -name .git | xargs rm -fr
cd ..
tar -zcvf shadowsocks-go.tar.gz shadowsocks-go
ffsend upload shadowsocks-go.tar.gz