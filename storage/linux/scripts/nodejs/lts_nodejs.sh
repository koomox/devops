#!/bin/bash

check_os_bits() {
	bit=$(uname -m)
	if [[ ${bit} == "x86_64" ]]; then
		bit="x64"
	elif [[ ${bit} == "i386" || ${bit} == "i686" ]]; then
		bit="x86"
	fi
}
check_os_bits

cd /tmp
\rm -rf /usr/local/node /tmp/node.tar.gz
mkdir -p /usr/local/node
NODE_VERSION=$(wget -q -O - https://nodejs.org/en/download/ | grep -E "Latest LTS Version" | sed -E "s/.*<strong>([0-9]+\.[0-9]+\.[0-9]+).*/\1/gm")
NODE_BITS=${bit}
wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz
xz -d node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz
tar -xf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar -C /opt/node
