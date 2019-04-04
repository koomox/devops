#!/bin/bash
if [ -d go-shadowsocks2 ]; then
	\rm -rf go-shadowsocks2;
fi
if [ -f go-shadowsocks2.tar.gz ]; then
	\rm -rf go-shadowsocks2.tar.gz
fi

mkdir go-shadowsocks2
cd go-shadowsocks2
mkdir -p ./src/github.com/shadowsocks/go-shadowsocks2
git clone https://github.com/shadowsocks/go-shadowsocks2.git ./src/github.com/shadowsocks/go-shadowsocks2 --depth=1
mkdir -p ./src/github.com/aead/chacha20
git clone https://github.com/aead/chacha20.git ./src/github.com/aead/chacha20 --depth=1
mkdir -p ./src/golang.org/x/sys
git clone https://github.com/golang/sys.git ./src/golang.org/x/sys --depth=1
mkdir -p ./src/golang.org/x/crypto
git clone https://github.com/golang/crypto.git ./src/golang.org/x/crypto --depth=1

#export GOPATH=$(pwd)
#go build -o ss-server github.com/shadowsocks/go-shadowsocks2

find . -name .git | xargs rm -fr
cd ..
tar -zcvf go-shadowsocks2.tar.gz go-shadowsocks2
ffsend upload go-shadowsocks2.tar.gz