#!/bin/bash
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
	sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' ${SSH_CONF}
	sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' ${SSH_CONF}
	sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' ${SSH_CONF}
	sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' ${SSH_CONF}
	sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' ${SSH_CONF}

	echo "======== set iptables rules================"

	# INPUT
	iptables -A INPUT -i lo -j ACCEPT
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${SSH_PORT} -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
	iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

	systemctl restart sshd

	iptables -P INPUT DROP
	iptables -P FORWARD DROP
	iptables -P OUTPUT ACCEPT

	iptables-save > /etc/iptables.rules

	echo '#!/bin/sh -e' > /etc/rc.local
	echo 'iptables-restore < /etc/iptables.rules' >> /etc/rc.local
	echo 'exit 0' >> /etc/rc.local
	chmod +x /etc/rc.local

	iptables -nvL
	echo -e "\n[Install]\nWantedBy=multi-user.target" >> /lib/systemd/system/rc-local.service
	systemctl daemon-reload
	systemctl enable rc-local
	systemctl start rc-local
	systemctl status rc-local
}

function get_public_address() {
	echo "================= Public IP ====================="
	curl https://checkip.amazonaws.com/
}

function os_optimize() {
	apt-get update -y
	apt-get upgrade -y
	apt-get install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential iputils-ping -y
	apt-get autoremove -y

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
	wget -O /etc/security/limits.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/limits.conf
	cat /etc/security/limits.conf
	sed -E -i '/^#*DefaultLimitNOFILE=/cDefaultLimitNOFILE=524288' /etc/systemd/system.conf
	grep -E '^#*DefaultLimitNOFILE=' /etc/systemd/system.conf

	echo "===== Optimize timedatectl ============"
	apt install dbus -y
	timedatectl set-timezone Asia/Shanghai
	timedatectl

	echo "===== Custom SSH Port And Iptabes Rules ========="
	custom_ssh_iptables

	get_public_address
}

os_optimize