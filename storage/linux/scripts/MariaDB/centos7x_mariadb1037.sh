#!/bin/bash
yum remove mariadb-libs -y

curl -o /etc/yum.repos.d/MariaDB.repo -L https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/MariaDB/10.3.7/MariaDB-Global.repo

yum install MariaDB-server MariaDB-client -y

systemctl enable mariadb
systemctl start mariadb
systemctl status mariadb