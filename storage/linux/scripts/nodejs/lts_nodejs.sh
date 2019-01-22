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
NODE_VERSION=$(wget -q -O - https://nodejs.org/en/download/ | grep -E "Latest LTS Version" | sed -E "s/.*<strong>([0-9]+\.[0-9]+\.[0-9]+).*/\1/gm")
NODE_BITS=${bit}

cd /tmp
if [ -d /usr/local/node ]; then
	\rm -rf /usr/local/node
fi
mkdir -p /usr/local/node
wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz
xz -d node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz
tar -xf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar
mv node-v${NODE_VERSION}-linux-${NODE_BITS} /usr/local/node
\rm -rf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz node-v${NODE_VERSION}-linux-${NODE_BITS}.tar