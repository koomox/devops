#!/bin/bash

go_environmental(){
	if grep -Eqi "/usr/local/telegram-desktop/bin" /etc/profile; then
		source /etc/profile
	else
		echo 'export PATH=$PATH:/usr/local/telegram-desktop/bin' >> /etc/profile
		source /etc/profile
	fi
}

TG_VERSION=$(wget -q -O - https://github.com/telegramdesktop/tdesktop/tags | grep -v "beta" | grep -v "rc" | grep -m1 -E "telegramdesktop/tdesktop/releases/tag/v[0-9]+\.[0-9]+\.*[0-9]*" | sed -E "s/.*v([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")

cd /tmp

if [ -f tsetup.{TG_VERSION}.tar.xz ]; then
	\rm -rf tsetup.{TG_VERSION}.tar.xz
fi

if [ -e /usr/local/telegram-desktop ]; then
	\rm -rf /usr/local/telegram-desktop
fi

mkdir -p /usr/local/telegram-desktop/bin

wget https://github.com/telegramdesktop/tdesktop/releases/download/v${TG_VERSION}/tsetup.${TG_VERSION}.tar.xz
xz -d tsetup.{TG_VERSION}.tar.xz
tar -xf tsetup.{TG_VERSION}.tar
