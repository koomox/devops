#!/bin/bash
cd /tmp
mkdir vlmcsd-1112-2018-10-20-Hotbird64
cd vlmcsd-1112-2018-10-20-Hotbird64
wget https://github.com/Wind4/vlmcsd/releases/download/svn1112/binaries.tar.gz
tar -zxf binaries.tar.gz
mkdir -p /usr/local/vlmcsd/bin /var/lib/vlmcsd
\cp -f ./binaries/Linux/arm/little-endian/glibc/vlmcsd-armv6hf-Raspberry-glibc /usr/local/vlmcsd/bin/vlmcsd

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

wget -O /etc/systemd/system/vlmcsd.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/vlmcsd/vlmcsd.service
systemctl enable vlmcsd
systemctl start vlmcsd
systemctl status vlmcsd