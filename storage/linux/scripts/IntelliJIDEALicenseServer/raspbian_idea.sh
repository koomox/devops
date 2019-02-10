#!/bin/bash
cd /tmp
mkdir -p /usr/local/idea/bin /var/lib/idea
unzip IntelliJIDEALicenseServer-1.6.zip
cd IntelliJIDEALicenseServer
\cp -f ./IntelliJIDEALicenseServer_linux_arm /usr/local/idea/bin/idea

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