#!/bin/bash
systemctl daemon-reload
systemctl stop tor
systemctl disable tor
systemctl daemon-reload
systemctl status tor
systemctl start tor
systemctl status tor

function create_system_user() {
	USERNAME=$1
	if ! `grep -Eq "^${USERNAME}" /etc/group`; then
		groupadd -r ${USERNAME}
	else
		echo "${USERNAME} Group Already Exist!"
	fi

	if ! `grep -Eq "^${USERNAME}" /etc/passwd`; then
		useradd -r -g ${USERNAME} -s /bin/false ${USERNAME}
	else
		echo "User ${USERNAME} Already Exist!"
	fi
}

init_nginx_service() {
	systemctl stop tor
	systemctl disable tor

	if [ -e /etc/systemd/system/tor.service ]; then
		\rm -rf /etc/systemd/system/tor.service
	fi

	if [ -e /lib/systemd/system/tor.service ]; then
		\rm -rf /lib/systemd/system/tor.service
	fi

	wget -O /etc/systemd/system/tor.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/tor/tor.service
	systemctl enable tor
	systemctl start tor
	systemctl status tor
}

echo "" > /etc/tor/torrc
vim /etc/tor/torrc

echo "" > /lib/systemd/system/tor.service
vim /lib/systemd/system/tor.service

/etc/apt/sources.list.d/tor.list

export http_proxy="http://127.0.0.1:10259"
export https_proxy="http://127.0.0.1:10259"
unset http_proxy
unset https_proxy

/etc/apt/sources.list.d/tor.list
deb https://deb.torproject.org/torproject.org stretch main
deb-src https://deb.torproject.org/torproject.org stretch main

mkdir make_tor && cd make_tor
wget https://github.com/libevent/libevent/releases/download/release-2.1.8-stable/libevent-2.1.8-stable.tar.gz
wget https://www.zlib.net/zlib-1.2.11.tar.gz
wget https://www.openssl.org/source/openssl-1.0.2r.tar.gz
wget https://dist.torproject.org/tor-0.4.0.5.tar.gz

tar -zxf libevent-2.1.8-stable.tar.gz
tar -zxf zlib-1.2.11.tar.gz
tar -zxf openssl-1.0.2r.tar.gz
tar -zxf tor-0.4.0.5.tar.gz

mkdir -p install

cd zlib-1.2.11
./configure --prefix=../install/zlib
make -j$(nproc)
make install
cd ..

cd libevent-2.1.8-stable
./configure --prefix=../install/libevent \
        --disable-shared \
        --enable-static \
        --with-pic
make -j$(nproc)
make install
cd ..

cd openssl-1.0.2r
./config --prefix=../install/openssl no-shared no-dso
make -j$(nproc)
make install
cd ..

cd tor-0.4.0.5
./configure --prefix=../install/tor \
            --disable-system-torrc \
            --enable-static-tor \
            --with-libevent-dir=../install/libevent \
            --with-openssl-dir=../install/openssl \
            --with-zlib-dir=../install/zlib
make -j$(nproc)
make install
cd ..

find /usr/local/bin -name "tor*" | xargs rm

cp -f ./install/tor/bin/* /usr/local/bin
ls /usr/local/bin | grep tor
tor --version