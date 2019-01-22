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
NODE_VERSION=$(wget -q -O - https://nodejs.org/en/download/current/ | grep -E "Latest Current Version" | sed -E "s/.*<strong>([0-9]+\.[0-9]+\.[0-9]+).*/\1/gm")
NODE_BITS=${bit}

cd /tmp
if [ -d /usr/local/node ]; then
	\rm -rf /usr/local/node
fi
if [ -f node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz ]; then
	\rm -rf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz
fi
if [ -f node-v${NODE_VERSION}-linux-${NODE_BITS}.tar ]; then
	\rm -rf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar
fi
wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz
xz -d node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz
tar -xf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar
mv node-v${NODE_VERSION}-linux-${NODE_BITS} /usr/local/node
\rm -rf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar.xz node-v${NODE_VERSION}-linux-${NODE_BITS}.tar

if grep -Eqi "NODE_HOME" /etc/profile; then
	source /etc/profile
else
	echo 'export NODE_HOME=/usr/local/node' >> /etc/profile
	echo 'export PATH=$PATH:$NODE_HOME/bin' >> /etc/profile
	echo 'export NODE_PATH=$PATH:$NODE_HOME/lib/node_modules' >> /etc/profile
	source /etc/profile
fi

echo "install Node.js ${NODE_VERSION} Success!"