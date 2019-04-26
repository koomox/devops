#!/bin/bash
wget -O /etc/systemd/system/x-server.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/xss/x-serv.service

systemctl enable x-serv.service
systemctl start x-serv.service
systemctl status x-serv.service