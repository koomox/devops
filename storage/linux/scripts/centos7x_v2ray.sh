#!/bin/bash
mkdir -p /tmp/v2ray
cd /tmp/v2ray
yum -y install curl unzip

curl -LO https://github.com/v2ray/v2ray-core/releases/download/v2.40/v2ray-linux-64.zip
unzip v2ray-linux-64.zip
\rm -rf /usr/local/v2ray
mv v2ray-v2.40-linux-64 /usr/local/v2ray
chmod +x /usr/local/v2ray/v2ray

mkdir -p /etc/v2ray
mkdir -p /var/log/v2ray

/usr/local/v2ray/v2ray --help

echo "install v2ray-core complete!"