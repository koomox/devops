#!/bin/bash
SS_CONF=/etc/shadowsocks-libev/ss-redir.json
server_method=aes-256-cfb

if [ -f /etc/systemd/system/shadowsocks-libev-redir@.service ]; then
	\rm -rf /etc/systemd/system/shadowsocks-libev-redir@.service
fi

wget -O /etc/systemd/system/shadowsocks-libev-redir@.service https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/shadowsocks/shadowsocks-libev/debian/shadowsocks-libev-redir%40.service

echo "=============== 初始化 shadowsocks-libev-redir ====================="
read -p "请输入服务器地址: " server_address
read -p "请输入服务器端口: " server_port
read -p "请输入服务器密钥: " server_secret
read -p "请输入加密协议:(aes-256-cfb) " server_method
read -p "请输入本地端口: " local_port

mkdir -p /etc/shadowsocks-libev
cat > ${SS_CONF} << EOF
{
    "server":"${server_address}",
    "server_port":${server_port},
    "local_address":"0.0.0.0",
    "local_port":${local_port},
    "password":"${server_secret}",
    "timeout":300,
    "method":"${server_method}",
}
EOF

echo "=========== ${SS_CONF} 配置文件内容 =============="
cat ${SS_CONF}

systemctl enable shadowsocks-libev-redir@ss-redir
systemctl start shadowsocks-libev-redir@ss-redir
systemctl status shadowsocks-libev-redir@ss-redir