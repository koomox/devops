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
			yum install wget unzip -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget unzip -y
		fi
	fi
}

if [ -e /usr/local/idea ]; then
	\rm -rf /usr/local/idea
fi
mkdir -p /usr/local/idea/bin

if [ -e /var/lib/idea ]; then
	\rm -rf /var/lib/idea
fi
mkdir -p /var/lib/idea

if [ -e /tmp/IntelliJIDEALicenseServer ]; then
	\rm -rf /tmp/IntelliJIDEALicenseServer
fi

unzip IntelliJIDEALicenseServer-1.6.zip

install_idea() {
	bit=$(uname -m)
	if [[ ${bit} == "x86_64" ]]; then
		\cp -f /tmp/IntelliJIDEALicenseServer/IntelliJIDEALicenseServer_linux_amd64 /usr/local/idea/bin/idea
	elif [[ ${bit} == "i386" || ${bit} == "i686" ]]; then
		\cp -f /tmp/IntelliJIDEALicenseServer/IntelliJIDEALicenseServer_linux_386 /usr/local/idea/bin/idea
	elif [[ ${bit} =~ "arm" ]]; then
		\cp -f /tmp/IntelliJIDEALicenseServer/IntelliJIDEALicenseServer_linux_arm /usr/local/idea/bin/idea
	fi
}

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

install_idea
create_system_user idea

chown -R idea:idea /var/lib/idea
chown -R idea:idea /usr/local/idea
chmod +x /usr/local/idea/bin/idea
ls -al /usr/local/idea/bin/idea

init_idea_service() {
	systemctl stop idea
	systemctl disable idea

	if [ -e /etc/systemd/system/idea.service ]; then
		\rm -rf /etc/systemd/system/idea.service
	fi

	if [ -e /lib/systemd/system/idea.service ]; then
		\rm -rf /lib/systemd/system/idea.service
	fi

	wget -O /etc/systemd/system/idea.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/IntelliJIDEALicenseServer/idea.service
	systemctl enable idea
	systemctl start idea
	systemctl status idea
}

init_idea_service