#!/bin/bash
if [ -d go-shadowsocks2 ]; then
	\rm -rf go-shadowsocks2;
fi
if [ -f go-shadowsocks2.tar.gz ]; then
	\rm -rf go-shadowsocks2.tar.gz
fi

git clone https://github.com/shadowsocks/go-shadowsocks2.git --depth=1
cd go-shadowsocks2
mkdir -p ./src/github.com/shadowsocks/go-shadowsocks2
mv core ./src/github.com/shadowsocks/go-shadowsocks2
mv socks ./src/github.com/shadowsocks/go-shadowsocks2
mv shadowaead ./src/github.com/shadowsocks/go-shadowsocks2
mv shadowstream ./src/github.com/shadowsocks/go-shadowsocks2
mkdir -p ./src/github.com/aead/chacha20
git clone https://github.com/aead/chacha20.git ./src/github.com/aead/chacha20 --depth=1
mkdir -p ./src/golang.org/x/crypto
git clone https://github.com/golang/crypto.git ./src/golang.org/x/crypto --depth=1
\rm -rf ./.git ./src/golang.org/x/crypto/.git ./src/github.com/aead/chacha20.git
cd ..
tar -zcvf go-shadowsocks2.tar.gz go-shadowsocks2
ffsend upload go-shadowsocks2.tar.gz