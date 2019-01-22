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

	if [ ! `command -v git >/dev/null` ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install git -y
			yum groupinstall "Development Tools" -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install git -y
			apt install build-essential -y
		fi
	fi
}

if [ -e /usr/local/vlmcsd ]; then
	\rm -rf /usr/local/vlmcsd
fi
mkdir -p /usr/local/vlmcsd/bin

if [ -e /var/lib/vlmcsd ]; then
	\rm -rf /var/lib/vlmcsd
fi
mkdir -p /var/lib/vlmcsd

if [ -e /tmp/vlmcsd ]; then
	\rm -rf /tmp/vlmcsd
fi

git clone https://github.com/Wind4/vlmcsd.git --depth=1 /tmp/vlmcsd
cd /tmp/vlmcsd && make
\cp -f /tmp/vlmcsd/bin/vlmcsd /usr/local/vlmcsd/bin/vlmcsd

groupadd -r vlmcsd
useradd -r -g vlmcsd -d /var/lib/vlmcsd -s /bin/false -c vlmcsd vlmcsd
chown -R vlmcsd:vlmcsd /var/lib/vlmcsd
chown -R vlmcsd:vlmcsd /usr/local/vlmcsd
chmod +x /usr/local/vlmcsd/bin/vlmcsd
ls -al /usr/local/vlmcsd/bin/vlmcsd

wget -O /etc/systemd/system/vlmcsd.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/vlmcsd/vlmcsd.service
systemctl enable vlmcsd
systemctl start vlmcsd
systemctl status vlmcsd