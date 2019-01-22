#!/bin/bash
cd /tmp
mkdir vlmcsd-1112-2018-10-20-Hotbird64
cd vlmcsd-1112-2018-10-20-Hotbird64
wget https://github.com/Wind4/vlmcsd/releases/download/svn1112/binaries.tar.gz
tar -zxf binaries.tar.gz
mkdir -p /usr/local/vlmcsd/bin /var/lib/vlmcsd
\cp -f ./binaries/Linux/intel/glibc/vlmcsd-x64-glibc /usr/local/vlmcsd/bin/vlmcsd


if [ ! `grep -Eq "^vlmcsd" /etc/group` ]; then
	groupadd -r vlmcsd
fi

if [ ! `grep -Eq "^vlmcsd" /etc/passwd` ]; then
	useradd -r -g vlmcsd -d /var/lib/vlmcsd -s /bin/false -c vlmcsd vlmcsd
fi

chown -R vlmcsd:vlmcsd /var/lib/vlmcsd
chown -R vlmcsd:vlmcsd /usr/local/vlmcsd
chmod +x /usr/local/vlmcsd/bin/vlmcsd
ls -al /usr/local/vlmcsd/bin/vlmcsd

init_vlmcsd_service() {
	if [ ! `systemctl list-units | grep 'vlmcsd'` ]; then
		systemctl stop vlmcsd
	fi

	if [ ! `systemctl list-unit-files | grep 'vlmcsd'` ]; then
		systemctl disable vlmcsd
	fi

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