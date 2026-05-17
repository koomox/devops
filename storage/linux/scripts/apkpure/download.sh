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

function check_os_bits() {
	bit=$(uname -m)
	if [[ ${bit} == "x86_64" ]]; then
		bit="amd64"
	elif [[ ${bit} == "i386" || ${bit} == "i686" ]]; then
		bit="386"
	elif [[ ${bit} =~ "arm" ]]; then
		bit="armv6l"
	fi
}

installation_dependency
check_os_bits

SKYPE_DOWN_LINK=$(wget -q -O - https://apkpure.com/skype-free-im-video-calls/com.skype.raider/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $SKYPE_DOWN_LINK

WHATSAPP_DOWN_LINK=$(wget -q -O - https://apkpure.com/whatsapp-messenger/com.whatsapp/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $WHATSAPP_DOWN_LINK

FB_DOWN_LINK=$(wget -q -O - https://apkpure.com/facebook/com.facebook.katana/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $FB_DOWN_LINK

TWITTER_DOWN_LINK=$(wget -q -O - https://apkpure.com/twitter/com.twitter.android/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $TWITTER_DOWN_LINK

INSTAGRAM_DOWN_LINK=$(wget -q -O - https://apkpure.com/instagram/com.instagram.android/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $INSTAGRAM_DOWN_LINK

TELEGRAM_DOWN_LINK=$(wget -q -O - https://apkpure.com/telegram/org.telegram.messenger/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $TELEGRAM_DOWN_LINK

SS_DOWN_LINK=$(wget -q -O - https://apkpure.com/shadowsocks/com.github.shadowsocks/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $SS_DOWN_LINK

LINE_DOWN_LINK=$(wget -q -O - https://apkpure.com/line-free-calls-messages/jp.naver.line.android/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $LINE_DOWN_LINK

WIRE_DOWN_LINK=$(wget -q -O - https://apkpure.com/wire-%E2%80%A2-secure-messenger/com.wire/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $WIRE_DOWN_LINK

SPOTIFY_DOWN_LINK=$(wget -q -O - https://apkpure.com/spotify-music/com.spotify.music/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $SPOTIFY_DOWN_LINK

CHROME_DOWN_LINK=$(wget -q -O - https://apkpure.com/google-chrome-fast-secure/com.android.chrome/download?from=details | grep -m1 -E ".*id=\"download_link\".*href=\"(.*)\">click here<\/a>" | sed -E "s/.*href=\"(.*)\".*/\1/gm")
wget --content-disposition $CHROME_DOWN_LINK

rename 's/ +/_/g' *