#!/bin/bash
SS_LOCAL_CONF=/etc/shadowsocks-libev/ss-local.json
server_method=aes-256-cfb

sudo sh -c 'printf "deb http://deb.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/stretch-backports.list'
sudo apt update
sudo apt -t stretch-backports install shadowsocks-libev

echo "=============== 初始化 shadowsocks-libev-Local ====================="
read -p "请输入服务器地址: " server_address
read -p "请输入服务器端口: " server_port
read -p "请输入服务器密钥: " server_secret
read -p "请输入加密协议:(aes-256-cfb) " server_method
read -p "请输入本地端口: " local_port

mkdir -p /etc/shadowsocks-libev
cat > ${SS_LOCAL_CONF} << EOF
{
    "server":"${server_address}",
    "server_port":${server_port},
    "local_address":"0.0.0.0",
    "local_port":${local_port},
    "password":"${server_secret}",
    "timeout":300,
    "method":"${server_method}",
    "fast_open":false
}
EOF

echo "=========== ${SS_LOCAL_CONF} 配置文件内容 =============="
cat ${SS_LOCAL_CONF}

systemctl enable shadowsocks-libev-local@ss-local
systemctl start shadowsocks-libev-local@ss-local
systemctl status shadowsocks-libev-local@ss-local