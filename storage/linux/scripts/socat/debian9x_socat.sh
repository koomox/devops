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

	if [ ! `command -v wget >/dev/null` ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install wget -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install wget -y
		fi
	fi
	if [ ! `command -v socat >/dev/null` ]; then
		if [[ ${release} == "CentOS" || ${release} == "Fedora" ]]; then
			yum install socat -y
		elif [[ ${release} == "Debian" || ${release} == "Ubuntu" || ${release} == "Raspbian" || ${release} == "Aliyun" ]]; then
			apt install socat -y
		fi
	fi
}

initialize_socat(){
	if [ -e /etc/socat ]; then
	\rm -rf /etc/socat
	fi
	mkdir -p /etc/socat

	wget https://raw.githubusercontent.com/koomox/devops/master/storage/linux/scripts/socat/run.sh -o /etc/socat/run.sh
	chmod +x /etc/socat/run.sh
}

socat_add_user() {
	read -p "输入用户名: " USERNAME
	read -p "输入转发IP地址: " IPADDR
	read -p "请输入 socat 转发端口号: " PUBLIC_PORT

	echo "socat_add_user ${USERNAME} ${IPADDR} ${PUBLIC_PORT}" >> /etc/socat/run.sh

	iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${PUBLIC_PORT} -j ACCEPT
	iptables -A OUTPUT -p tcp --sport ${PUBLIC_PORT} -j ACCEPT
	iptables -A OUTPUT -p tcp --dport ${PUBLIC_PORT} -j ACCEPT

	nohup socat TCP4-LISTEN:${PUBLIC_PORT},reuseaddr,fork TCP4:${IPADDR}:${PUBLIC_PORT} >> /var/log/socat.log 2>&1 &
	nohup socat UDP4-LISTEN:${PUBLIC_PORT},reuseaddr,fork UDP4:${IPADDR}:${PUBLIC_PORT} >> /var/log/socat.log 2>&1 &
}

# 开始菜单
start_menu() {
	clear
	echo "============================="
	echo "环境: 适用于 Debian 9.x"
	echo "Author: allen.w"
	echo "============================="
	echo "1. 安装 socat"
	echo "2. 初始化 socat"
	echo "3. 添加用户并立即运行"
	echo "4. 退出脚本"
	echo 
	read -p "请输入数字: " num
	case "$num" in
		1)
			installation_dependency
			;;
		2)
			initialize_socat
			;;
		3)
			socat_add_user
			;;
		4)
			exit 1
			;;
		*)
			clear
			echo "请输入正确的数字"
			sleep 5s
			start_menu
			;;
	esac
}

while true
do
	start_menu
done