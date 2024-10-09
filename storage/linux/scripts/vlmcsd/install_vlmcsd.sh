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

	if ! `command -v git >/dev/null` ; then
		if ${release} == "CentOS" || ${release} == "Fedora"; then
			yum install wget git -y
			yum groupinstall "Development Tools" -y
		elif ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun"; then
			apt install wget git -y
			apt install build-essential -y
		fi
	fi
}

installation_dependency

if [ -e /usr/local/vlmcsd ]; then
	\rm -rf /usr/local/vlmcsd
fi
mkdir -p /usr/local/vlmcsd/bin

if [ -e /var/lib/vlmcsd ]; then
	\rm -rf /var/lib/vlmcsd
fi
mkdir -p /var/lib/vlmcsd
touch /var/lib/vlmcsd/vlmcsd.log

if [ -e /tmp/vlmcsd ]; then
	\rm -rf /tmp/vlmcsd
fi

git clone https://github.com/Wind4/vlmcsd.git --depth=1 /tmp/vlmcsd
cd /tmp/vlmcsd && make
\cp -f /tmp/vlmcsd/bin/vlmcsd /usr/local/vlmcsd/bin/vlmcsd
\rm -rf /tmp/vlmcsd

function create_system_user() {
	SYSTEM_USERNAME=$1
	grep -E "^${SYSTEM_USERNAME}" /etc/group >& /dev/null
	if [ $? -ne 0 ]; then
		groupadd -r ${SYSTEM_USERNAME}
	fi

	grep -E "^${SYSTEM_USERNAME}" /etc/passwd >& /dev/null
	if [ $? -ne 0 ]; then
		useradd -r -g ${SYSTEM_USERNAME} -d /var/lib/${SYSTEM_USERNAME} -s /bin/false -c ${SYSTEM_USERNAME} ${SYSTEM_USERNAME}
	fi
}

create_system_user vlmcsd

chown -R vlmcsd:vlmcsd /var/lib/vlmcsd
chown -R vlmcsd:vlmcsd /usr/local/vlmcsd
chmod +x /usr/local/vlmcsd/bin/vlmcsd
ls -al /usr/local/vlmcsd/bin/vlmcsd

function init_vlmcsd_service() {
	systemctl stop vlmcsd
	systemctl disable vlmcsd

	if [ -e /etc/systemd/system/vlmcsd.service ]; then
		\rm -rf /etc/systemd/system/vlmcsd.service
	fi

	if [ -e /lib/systemd/system/vlmcsd.service ]; then
		\rm -rf /lib/systemd/system/vlmcsd.service
	fi

	wget -O /etc/systemd/system/vlmcsd.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/vlmcsd/vlmcsd.service
	systemctl enable vlmcsd
	systemctl start vlmcsd
	systemctl status vlmcsd
}

init_vlmcsd_service