#!/bin/bash

function installation_dependency(){
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

	if ! `command -v wget >/dev/null`; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
}

TG_VERSION=$(wget -q -O - https://github.com/telegramdesktop/tdesktop/tags | grep -v "beta" | grep -v "rc" | grep -m1 -E "telegramdesktop/tdesktop/releases/tag/v[0-9]+\.[0-9]+\.*[0-9]*" | sed -E "s/.*v([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")
TG_FILE_NAME=tsetup.${TG_VERSION}
TG_FULL_NAME=tsetup.${TG_VERSION}.tar.xz
TG_DOWNLOAD_LINK=https://github.com/telegramdesktop/tdesktop/releases/download/v${TG_VERSION}/tsetup.${TG_VERSION}.tar.xz

function downloadFunc() {
	fileName=$1
	downLink=$2
	if [ -f ${fileName} ]; then
		echo "Found file ${fileName} Already Exist!"
	else
		wget ${downLink}
	fi
}

function deCompressFunc() {
	fileName=$1
	if [ -e ${fileName} ]; then
		\rm -rf ${fileName}
	fi
	tar -zxf ${fileName}
}

downloadFunc ${TG_FILE_NAME} ${TG_DOWNLOAD_LINK}


if [ -e /opt/Telegram ]; then
	\rm -rf /opt/Telegram
fi

wget 
xz -d tsetup.${TG_VERSION}.tar.xz
tar -xf tsetup.${TG_VERSION}.tar -C /opt
\rm -rf tsetup.${TG_VERSION}.tar.xz tsetup.${TG_VERSION}.tar

if [ -e ~/.local/share/TelegramDesktop ]; then
	\rm -rf ~/.local/share/TelegramDesktop
fi

echo "The Telegram-Desktop ${TG_VERSION} install Success!"