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

function install_ffsend() {
	FFSEND_VERSION=$(wget -q -O - https://github.com/timvisee/ffsend/tags | grep -m1 -E "/timvisee/ffsend/releases/tag/v[0-9]+\.[0-9]+\.*[0-9]*" | sed -E "s/.*v([0-9]+\.[0-9]+\.*[0-9]*).*/\1/gm")
	FFSEND_FULL_NAME=ffsend-v${FFSEND_VERSION}-linux-x64-static
	FFSEND_DOWNLOAD_LINK=https://github.com/timvisee/ffsend/releases/download/v${FFSEND_VERSION}/${FFSEND_FULL_NAME}

	downloadFunc ${FFSEND_FULL_NAME} ${FFSEND_DOWNLOAD_LINK}
	chmod +x ./${FFSEND_FULL_NAME}
	mv ${FFSEND_FULL_NAME} /usr/bin/ffsend
	ffsend -h
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

	echo "===== reset iptables rules======"
	iptables -P INPUT ACCEPT
	iptables -P FORWARD ACCEPT
	iptables -P OUTPUT ACCEPT
	iptables -F
	iptables -X
	iptables -Z
	iptables -nvL

	#修改SSH为证书登录
	setenforce 0
	sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' ${SSH_CONF}
	sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' ${SSH_CONF}
	sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' ${SSH_CONF}
	sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' ${SSH_CONF}
	sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' ${SSH_CONF}

	echo "======== set iptables rules================"

	# INPUT
	iptables -A INPUT -i lo -j ACCEPT
	# iptables -A INPUT -m icmp -p icmp --icmp-type any -j ACCEPT
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	# iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
	iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${SSH_PORT} -j ACCEPT
	iptables -A INPUT -p udp --sport 53 -j ACCEPT
	iptables -A INPUT -p udp --sport 123 -j ACCEPT
	iptables -A INPUT -p tcp --sport 16630 -j ACCEPT

	# OUTPUT
	iptables -A OUTPUT -o lo -j ACCEPT
	iptables -A OUTPUT -m icmp -p icmp --icmp-type any -j ACCEPT
	iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

	iptables -A OUTPUT -p tcp --sport ${SSH_PORT} -j ACCEPT
	iptables -A OUTPUT -p tcp --dport ${SSH_PORT} -j ACCEPT

	iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
	iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
	iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 1080 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 5222 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 5223 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 5228 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 5229 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 5230 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 8000 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 8080 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 8181 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 14000 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 16630 -j ACCEPT

	### Telegram
	iptables -A OUTPUT -p tcp --dport 8888 -j ACCEPT

	### Outlook.com
	iptables -A OUTPUT -p tcp --dport 993 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT

	### gmail
	iptables -A OUTPUT -p tcp --dport 995 -j ACCEPT
	iptables -A OUTPUT -p tcp --dport 465 -j ACCEPT

	systemctl restart sshd

	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT DROP

	iptables-save > /etc/iptables.rules

	systemctl enable rc.local
	systemctl start rc.local
	echo '#!/bin/sh -e' > /etc/rc.local
	echo 'iptables-restore < /etc/iptables.rules' >> /etc/rc.local
	echo 'exit 0' >> /etc/rc.local
	chmod +x /etc/rc.local

	iptables -nvL
}

function get_publicIP() {
	echo "================= Public IP ====================="
	global_ip=$(curl whatismyip.akamai.com)
	echo "Public IP: ${global_ip}"
}

function os_optimize() {
	installation_dependency
	check_os_bits
	apt update -y
	apt upgrade -y
	apt install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential -y
	install_ffsend

	echo "===== Optimize sysctl.conf ============="
	cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
	wget -O /etc/sysctl.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/aliyun.lightsail.sysctl.conf
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