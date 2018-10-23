#!/bin/bash
yum remove mariadb-libs -y

curl -o /etc/yum.repos.d/MariaDB.repo -L https://gitee.com/koomox/devops/raw/master/storage/linux/scripts/MariaDB/10.3.7/MariaDB-Tuna.repo

yum install MariaDB-server MariaDB-client -y

systemctl enable mariadb
systemctl start mariadb
systemctl status mariadb