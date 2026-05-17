#!/bin/bash

function installation_dependency(){
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

	if ! `command -v wget >/dev/null`; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
}

function check_os_bits() {
	bit=$(uname -m)
	if [[ ${bit} == "x86_64" ]]; then
		bit="x64"
	elif [[ ${bit} == "i386" || ${bit} == "i686" ]]; then
		bit="x86"
	fi
}

function downloadFunc() {
	fileName=$1
	downLink=$2
	if [ -f ${fileName} ]; then
		echo "Found file ${fileName} Already Exist!"
	else
		wget ${downLink}
	fi
}

function node_environmental(){
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
NODE_VERSION=$(wget -q -O - https://nodejs.org/en/download/ | grep -E "Latest LTS Version" | sed -E "s/.*<strong>([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")
NODE_BITS=${bit}
NODE_FILE_NAME=node-v${NODE_VERSION}-linux-${NODE_BITS}
NODE_FULL_NAME=${NODE_FILE_NAME}.tar.xz
NODE_DOWNLOAD_LINK=https://nodejs.org/dist/v${NODE_VERSION}/${NODE_FULL_NAME}

cd /tmp
if [ -e /usr/local/node ]; then
	\rm -rf /usr/local/node
fi

if [ -f node-v${NODE_VERSION}-linux-${NODE_BITS}.tar ]; then
	\rm -rf node-v${NODE_VERSION}-linux-${NODE_BITS}.tar
fi

downloadFunc ${NODE_FULL_NAME} ${NODE_DOWNLOAD_LINK}

mkdir -p /usr/local/node
xz -d ${NODE_FULL_NAME}
tar --strip-components 1 -C /usr/local/node -xf ${NODE_FILE_NAME}.tar

node_environmental
echo "install Node.js ${NODE_VERSION} Success!"
node -v