#!/bin/bash
SS_CONF=/etc/shadowsocks-libev/ss-server.json
server_method=aes-256-cfb

if [ -f /etc/systemd/system/shadowsocks-libev-server@.service ]; then
	\rm -rf /etc/systemd/system/shadowsocks-libev-server@.service
fi

wget -O /etc/systemd/system/shadowsocks-libev-server@.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian/shadowsocks-libev-server%40.service

echo "=============== 初始化 shadowsocks-libev-server ====================="
read -p "请输入服务器地址: " server_address
read -p "请输入服务器端口: " server_port
read -p "请输入服务器密钥: " server_secret
read -p "请输入加密协议:(aes-256-cfb) " server_method
read -p "请输入本地端口: (53)" local_port

mkdir -p /etc/shadowsocks-libev
cat > ${SS_CONF} << EOF
{
    "server":"${server_address}",
    "server_port":${server_port},
    "password":"${server_secret}",
    "timeout":300,
    "method":"${server_method}",
    "mode": "tcp_and_udp",
}
EOF

echo "=========== ${SS_CONF} 配置文件内容 =============="
cat ${SS_CONF}

systemctl enable shadowsocks-libev-server@ss-server
systemctl start shadowsocks-libev-server@ss-server
systemctl status shadowsocks-libev-server@ss-server