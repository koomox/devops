#!/bin/bash
NODE_VER=v6.14.4
MTPROXY_PORT=443
MTPROXY_SECRET="*****"
echo "========= setting Node.js Version ======"
echo "please input Node.js Version: "
read NODE_VER
echo "${NODE_VER}"

echo "========= setting MTProxy Port And Secret ======"
echo "please input MTProxy PORT: "
read MTPROXY_PORT
echo "========= MTProxy PORT ============="
echo "${MTPROXY_PORT}"

echo "please input MTProxy Secret: "
read MTPROXY_SECRET
echo "========= MTProxy Secret ============="
echo "${MTPROXY_SECRET}"

cd /tmp
apt-get install curl git
curl -LO https://nodejs.org/dist/latest-v6.x/node-${NODE_VER}-linux-x64.tar.xz
xz -d node-${NODE_VER}-linux-x64.tar.xz
tar -xf node-${NODE_VER}-linux-x64.tar
\rm -rf /usr/local/node
mv node-${NODE_VER}-linux-x64 /usr/local/node
echo 'export NODE_HOME=/usr/local/node' >> /etc/profile
echo 'export PATH=$PATH:$NODE_HOME/bin' >> /etc/profile
echo 'export NODE_PATH=$PATH:$NODE_HOME/lib/node_modules' >> /etc/profile
source /etc/profile

npm install -g pm2
cd /opt
git clone https://github.com/FreedomPrevails/JSMTProxy.git

echo -e "{\n\t\"port\":${MTPROXY_PORT}\n\t\"secret\":\"${MTPROXY_SECRET}\"\n}" > /opt/JSMTProxy/config.json

iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${MTPROXY_PORT} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${MTPROXY_PORT} -j ACCEPT

iptables-save > /etc/iptables.rules

cd /opt/JSMTProxy && pm2 start mtproxy.js -i max

pm2 save
pm2 startup