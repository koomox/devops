#!/bin/bash

check_sys(){
	if grep -Eqi "CentOS|Red Hat|RedHat" /etc/issue || grep -Eq "CentOS|Red Hat|RedHat" /etc/*-release || grep -Eqi "CentOS|Red Hat|RedHat" /proc/version; then
		release="CentOS"
	elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
		release="Debian"
	elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release || grep -Eqi "Fedora" /proc/version; then
		release="Fedora"
	elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release || grep -Eqi "Ubuntu" /proc/version; then
		release="Ubuntu"
	elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
		release="Raspbian"
	elif grep -Eqi "Aliyun" /etc/issue || grep -Eq "Aliyun" /etc/*-release; then
		release="Aliyun"
	else
		release="unknown"
	fi

	if [ ! -f /usr/bin/wget ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
}

check_os_bits() {
	bit=$(uname -m)
	if [[ ${bit} == "x86_64" ]]; then
		bit="x64"
	elif [[ ${bit} == "i386" || ${bit} == "i686" ]]; then
		bit="x86"
	fi
}

node_environmental(){
	if grep -Eqi "NODE_HOME" /etc/profile; then
		source /etc/profile
	else
		echo 'export NODE_HOME=/usr/local/node' >> /etc/profile
		echo 'export PATH=$PATH:$NODE_HOME/bin' >> /etc/profile
		echo 'export NODE_PATH=$PATH:$NODE_HOME/lib/node_modules' >> /etc/profile
		source /etc/profile
	fi
}

check_sys
check_os_bits
NODE_VERSION=$(wget -q -O - https://nodejs.org/en/download/current/ | grep -E "Latest Current Version" | sed -E "s/.*<strong>([0-9]+\.[0-9]+\.[0-9]+).*/\1/gm")
NODE_BITS=${bit}

cd /tmp
if [ -e /usr/local/node ]; then
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

node_environmental
echo "install Node.js ${NODE_VERSION} Success!"
node -v