#!/bin/bash
yum install wget git -y
cd /tmp
\rm -rf /usr/local/node /tmp/node.tar.gz
mkdir -p /usr/local/node
wget https://nodejs.org/dist/latest/`wget \
	https://nodejs.org/dist/latest/SHASUMS256.txt \
	-qO- | awk '{print $2}' | grep linux-x64.*gz` \
	-O /tmp/node.tar.gz

tar --strip-components 1 -C /usr/local/node -zxf /tmp/node.tar.gz

echo 'export NODE_HOME=/usr/local/node' >> /etc/profile
echo 'export PATH=$PATH:$NODE_HOME/bin' >> /etc/profile
echo 'export NODE_PATH=$PATH:$NODE_HOME/lib/node_modules' >> /etc/profile
source /etc/profile