#!/bin/bash

installation_dependency(){
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

	if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
		if [ ! `command -v git >/dev/null` ]; then
			yum install git -y
		fi
		if [ ! `command -v wget >/dev/null` ]; then
			yum install wget -y
		fi
	elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
		if [ ! `command -v git >/dev/null` ]; then
			apt install git -y
		fi
		if [ ! `command -v wget >/dev/null` ]; then
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

installation_dependency
check_os_bits
NODE_BITS=${bit}

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

apt install wget git -y
cd /tmp
if [ -e /usr/local/node ]; then
	\rm -rf /usr/local/node
fi
mkdir -p /usr/local/node

if [ -f /tmp/node.tar.gz ]; then
	\rm -rf /tmp/node.tar.gz
fi

wget https://nodejs.org/dist/latest-v6.x/`wget \
	https://nodejs.org/dist/latest-v6.x/SHASUMS256.txt \
	-qO- | awk '{print $2}' | grep linux-${NODE_BITS}.*gz` \
	-O /tmp/node.tar.gz
cd /usr/local/node >> tar --strip-components 1 -xf /tmp/node.tar.gz

node_environmental

npm install -g pm2 -y
cd /opt
git clone https://github.com/FreedomPrevails/JSMTProxy.git --depth=1

echo -e "{\n\t\"port\":${MTPROXY_PORT}\n\t\"secret\":\"${MTPROXY_SECRET}\"\n}" > /opt/JSMTProxy/config.json

iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${MTPROXY_PORT} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${MTPROXY_PORT} -j ACCEPT

iptables-save > /etc/iptables.rules

cd /opt/JSMTProxy && pm2 start mtproxy.js -i max

pm2 save
pm2 startup