#!/bin/bash
cd /tmp
mkdir -p /usr/local/idea/bin /var/lib/idea
unzip IntelliJIDEALicenseServer-1.6.zip
cd IntelliJIDEALicenseServer
\cp -f ./IntelliJIDEALicenseServer_linux_amd64 /usr/local/idea/bin/idea

groupadd -r idea
useradd -r -g idea -d /var/lib/idea -s /bin/false -c idea idea
chown -R idea:idea /var/lib/idea
chown -R idea:idea /usr/local/idea
chmod +x /usr/local/idea/bin/idea
ls -al /usr/local/idea/bin/idea

wget -O /etc/systemd/system/idea.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/IntelliJIDEALicenseServer/idea.service
systemctl enable idea
systemctl start idea
systemctl status idea