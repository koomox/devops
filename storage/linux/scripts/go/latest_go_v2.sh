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
		bit="amd64"
	elif [[ ${bit} == "i386" || ${bit} == "i686" ]]; then
		bit="386"
	elif [[ ${bit} =~ "arm" ]]; then
		bit="armv6l"
	fi
}

function go_environmental(){
	if grep -Eqi "/usr/local/go/bin" /etc/profile; then
		source /etc/profile
	else
		echo 'export PATH=$PATH:/usr/local/go/bin' >> /etc/profile
		source /etc/profile
	fi
}

installation_dependency
check_os_bits
GO_VERSION=$(wget -q -O - https://golang.org/ | grep -E "goVersion" | sed -E "s/.*go([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")
GO_BITS=${bit}

if [ -f /tmp/go${GO_VERSION}.linux-${GO_BITS}.tar.gz ]; then
	\rm -rf /tmp/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
fi
if [ -e /usr/local/go ]; then
	\rm -rf /usr/local/go
fi

wget -O /tmp/go${GO_VERSION}.linux-${GO_BITS}.tar.gz https://dl.google.com/go/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
tar -C /usr/local -xzf /tmp/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
\rm -rf /tmp/go${GO_VERSION}.linux-${GO_BITS}.tar.gz

go_environmental
echo "The Go Programming Language ${GO_VERSION} install Success!"
go version