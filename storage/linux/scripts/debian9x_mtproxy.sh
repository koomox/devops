#!/bin/bash
MTPROXY_PORT=443
MTPROXY_SECRET="*****"

echo "========= setting MTProxy Port And Secret ======"
echo "please input MTProxy PORT: "
read MTPROXY_PORT
echo "========= MTProxy PORT ============="
echo "${MTPROXY_PORT}"

echo "please input MTProxy Secret: "
read MTPROXY_SECRET
echo "========= MTProxy Secret ============="
echo "${MTPROXY_SECRET}"

\rm -rf /opt/MTProxy /usr/local/MTProxy
mkdir -p /usr/local/MTProxy
cd /opt
apt-get install git curl build-essential libssl-dev zlib1g-dev -y
git clone https://github.com/TelegramMessenger/MTProxy
cd MTProxy
make && cd objs/bin
mv mtproto-proxy -t /usr/local/MTProxy
cd /usr/local/MTProxy
curl -s https://core.telegram.org/getProxySecret -o proxy-secret
curl -s https://core.telegram.org/getProxyConfig -o proxy-multi.conf

cat > /etc/systemd/system/MTProxy.service << EOF
[Unit]
Description=MTProxy
After=network.target

[Service]
Type=simple
WorkingDirectory=/usr/local/MTProxy
ExecStart=/usr/local/MTProxy/mtproto-proxy -u nobody -p 8888 -H ${MTPROXY_PORT} -S "${MTPROXY_SECRET}" --aes-pwd proxy-secret proxy-multi.conf -M 1
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${MTPROXY_PORT} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${MTPROXY_PORT} -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8888 -j ACCEPT

iptables-save > /etc/iptables.rules

systemctl daemon-reload
systemctl restart MTProxy.service
systemctl enable MTProxy.service
systemctl status MTProxy.service