#!/bin/bash
apt-get update -y
apt-get upgrade -y
sudo sh -c 'printf "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list'
sudo apt update -y
sudo apt -t stretch-backports install shadowsocks-libev -y
ldd -r /usr/bin/ss-server

systemctl stop shadowsocks-libev
systemctl disable shadowsocks-libev
systemctl status shadowsocks-libev