#!/bin/bash

installation_dependency(){
	if grep -Eqi "CentOS|Red Hat|RedHat" /etc/issue || grep -Eq "CentOS|Red Hat|RedHat" /etc/*-release || grep -Eqi "CentOS|Red Hat|RedHat" /proc/version; then
		release="CentOS"
	elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
		release="Debian"
	elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release || grep -Eqi "Fedora" /proc/version; then
		release="Fedora"
	elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release || grep -Eqi "Ubuntu" /proc/version; then
		release="Ubuntu"
	elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
		release="Raspbian"
	elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
		release="Aliyun"
	else
		release="unknown"
	fi

	if [ ! `command -v wget >/dev/null` ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
}

tg_environmental(){
	if grep -Eqi "/usr/local/telegram-desktop/bin" /etc/profile; then
		source /etc/profile
	else
		echo 'export PATH=$PATH:/usr/local/telegram-desktop/bin' >> /etc/profile
		source /etc/profile
	fi
}

TG_VERSION=$(wget -q -O - https://github.com/telegramdesktop/tdesktop/tags | grep -v "beta" | grep -v "rc" | grep -m1 -E "telegramdesktop/tdesktop/releases/tag/v[0-9]+\.[0-9]+\.*[0-9]*" | sed -E "s/.*v([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")

cd /tmp

if [ -f tsetup.${TG_VERSION}.tar.xz ]; then
	\rm -rf tsetup.${TG_VERSION}.tar.xz
fi

if [ -e /usr/local/telegram-desktop ]; then
	\rm -rf /usr/local/telegram-desktop
fi

if [ -e /tmp/Telegram ]; then
	\rm -rf /tmp/Telegram
fi

mkdir -p /usr/local/telegram-desktop/bin

wget https://github.com/telegramdesktop/tdesktop/releases/download/v${TG_VERSION}/tsetup.${TG_VERSION}.tar.xz
xz -d tsetup.${TG_VERSION}.tar.xz
tar -xf tsetup.${TG_VERSION}.tar
cd /tmp/Telegram
mv Telegram Updater -t /usr/local/telegram-desktop/bin
cd /tmp
\rm -rf /tmp/Telegram tsetup.${TG_VERSION}.tar.xz tsetup.${TG_VERSION}.tar

if [ -e ~/.local/share/TelegramDesktop ]; then
	\rm -rf ~/.local/share/TelegramDesktop
fi

tg_environmental
echo "The Telegram-Desktop ${TG_VERSION} install Success!"