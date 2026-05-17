#!/bin/bash
cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
echo "" > /etc/sysctl.conf
vim /etc/sysctl.conf
cat > /etc/sysctl.conf << EOF
fs.file-max = 60000

net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 0

# 20 min * 60 second = 1200
net.ipv4.tcp_keepalive_time = 1200

net.ipv4.ip_forward = 1

kernel.sysrq = 1
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr

net.core.netdev_max_backlog = 50000
net.core.somaxconn = 10000

net.nf_conntrack_max = 65536000
net.netfilter.nf_conntrack_tcp_timeout_established = 1200
EOF
modprobe ip_conntrack
lsmod |grep conntrack
sysctl -p

cp -f /etc/security/limits.conf /etc/security/limits.conf.bak
echo "" > /etc/security/limits.conf
vim /etc/security/limits.conf
cat > /etc/security/limits.conf << EOF
*         hard    nofile      10000
*         soft    nofile      10000
*         hard    nproc       10000
*         soft    nproc       10000
EOF
cat /etc/security/limits.conf

echo "ulimit -SHn 60000" >> /etc/profile
ulimit -SHn 60000

