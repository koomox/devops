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

function custom_ssh_iptables() {
	SSH_CONF="/etc/ssh/sshd_config"
	SSH_PORT=22

	echo "========= setting SSH and internat ip and ipsec secrets ======"
	echo "please input SSH PORT: "
	read SSH_PORT
	echo "========= SSH PORT ============="
	echo "${SSH_PORT}"
	echo "please input SSH: "
	read SSH_KEY
	echo "========= SSH ============="
	echo "${SSH_KEY}"

	if [ ! -x "~/.ssh" ];then
		mkdir -p ~/.ssh
	fi
	echo -e "${SSH_KEY}" > ~/.ssh/authorized_keys
	echo "====== read ~/.ssh/authorized_keys ========"
	cat ~/.ssh/authorized_keys

	#修改SSH为证书登录
	setenforce 0
	sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' ${SSH_CONF}
	sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' ${SSH_CONF}
	sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' ${SSH_CONF}
	sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' ${SSH_CONF}
	sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' ${SSH_CONF}

	echo "======== set iptables rules================"

	# INPUT
	ufw --force reset
	ufw default deny incoming
	ufw default allow outgoing
	ufw allow 22/tcp
	ufw allow 80/tcp
	ufw allow 443/tcp
	ufw allow ${SSH_PORT}/tcp
	ufw default deny
	ufw --force enable
	ufw status
}

function get_publicIP() {
	echo "================= Public IP ====================="
	curl https://checkip.amazonaws.com/
}

function os_optimize() {
	installation_dependency
	check_os_bits
	apt update -y
	apt upgrade -y
	apt install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential -y

	echo "===== Optimize sysctl.conf ============="
	cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
	wget -O /etc/sysctl.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/aws.lightsail.sysctl.conf
	modprobe ip_conntrack
	lsmod |grep conntrack
	sysctl -p
	sysctl net.ipv4.tcp_available_congestion_control
	lsmod | grep bbr
	

	echo "===== Optimize limits.conf ============="
	cp -f /etc/security/limits.conf /etc/security/limits.conf.bak
	wget -O /etc/security/limits.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/aliyun.limits.conf
	cat /etc/security/limits.conf
	echo "ulimit -SHn 60000" >> /etc/profile
	ulimit -SHn 60000

	echo "===== Optimize timedatectl ============"
	apt install dbus -y
	timedatectl set-timezone Asia/Shanghai
	timedatectl

	echo "===== Custom SSH Port And Iptabes Rules ========="
	custom_ssh_iptables

	get_publicIP
}

os_optimize