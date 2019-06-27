#!/bin/bash

function deploy_heroku() {
	PROJECTNAME=""
	read -p "please input GO Project Name: " PROJECTNAME
	if [ -e ${PROJECTNAME} ]; then
		\rm -rf ${PROJECTNAME}
	fi
	mkdir -p ${PROJECTNAME}/src/${PROJECTNAME} && cd ${PROJECTNAME}
	export GOPATH=$(pwd)
	go get -u -d github.com/gin-gonic/gin
	go get -u -d github.com/PuerkitoBio/goquery
	go get -u -d github.com/brianvoe/gofakeit
	cd src/${PROJECTNAME}
	wget -O main.go https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/heroku/heroku.go
	govendor init
	govendor add +external
	pwd
	ls vendor
	cd ../${GOPATH}
}

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

function install_govendor() {
	if [ -e govendor ]; then
		\rm -rf govendor
	fi
	mkdir -p govendor && cd govendor
	export GOPATH=$(pwd)
	go get -u -d github.com/kardianos/govendor
	go install github.com/kardianos/govendor
	\cp -f $GOPATH/bin/govendor /usr/local/go/bin/govendor
	govendor -version
	cd ..
}

function install_go() {
	installation_dependency
	check_os_bits
	GO_VERSION=$(wget -q -O - https://golang.org/dl/ | grep -m1 -E "go[0-9]+\.[0-9]+\.*[0-9]*\.linux.*\.tar\.gz" | sed -E "s/.*go([0-9]+\.[0-9]+\.*[0-9]*)\.linux.*\.tar\.gz.*/\1/gm")
	GO_BITS=${bit}
	if [ -f go${GO_VERSION}.linux-${GO_BITS}.tar.gz ]; then
		\rm -rf go${GO_VERSION}.linux-${GO_BITS}.tar.gz
	fi
	if [ -e /usr/local/go ]; then
		\rm -rf /usr/local/go
	fi
	wget https://dl.google.com/go/go${GO_VERSION}.linux-${GO_BITS}.tar.gz
	tar -C /usr/local -xzf go${GO_VERSION}.linux-${GO_BITS}.tar.gz
	\rm -rf go${GO_VERSION}.linux-${GO_BITS}.tar.gz
	go_environmental
	echo "The Go Programming Language ${GO_VERSION} install Success!"
	go version
}

function auto_install_deploy_heroku_go() {
	install_go
	install_govendor
	deploy_heroku
}

auto_install_deploy_heroku_go