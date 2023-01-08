#!/bin/bash
if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

echo "===== Optimize System ============="
${SUDO} apt-get update -y
${SUDO} apt-get upgrade -y
${SUDO} apt-get install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential iputils-ping -y

echo "===== Optimize sysctl.conf ============="
${SUDO} cp -f /etc/sysctl.conf /etc/sysctl.conf.bak
${SUDO} wget -O /etc/sysctl.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/aws.lightsail.sysctl.conf
${SUDO} modprobe ip_conntrack
lsmod |grep conntrack
${SUDO} sysctl -p
${SUDO} sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

echo "===== Optimize limits.conf ============="
${SUDO} cp -f /etc/security/limits.conf /etc/security/limits.conf.bak
${SUDO} wget -O /etc/security/limits.conf https://raw.githubusercontent.com/koomox/devops/master/storage/linux/debian/sysctl/limits.conf
cat /etc/security/limits.conf
${SUDO} sed -E -i '/^#*DefaultLimitNOFILE=/cDefaultLimitNOFILE=524288' /etc/systemd/system.conf
grep -E '^#*DefaultLimitNOFILE=' /etc/systemd/system.conf

echo "===== Optimize timedatectl ============"
${SUDO} apt install dbus -y
${SUDO} timedatectl set-timezone Asia/Shanghai
timedatectl

echo "===== Custom SSH Port And Iptabes Rules ========="
echo "input SSH Port: "
read SSH_PORT
echo "input SSH Key: "
read SSH_KEY
echo "SSH Port: ${SSH_PORT}"
echo "========= SSH ============="
echo "${SSH_KEY}"

if [ ! -x "~/.ssh" ];then
	mkdir -p ~/.ssh
fi
echo -e "${SSH_KEY}" > ~/.ssh/authorized_keys
echo "====== read ~/.ssh/authorized_keys ========"
cat ~/.ssh/authorized_keys

echo "===== reset iptables rules======"
${SUDO} iptables -P INPUT ACCEPT
${SUDO} iptables -P FORWARD ACCEPT
${SUDO} iptables -P OUTPUT ACCEPT
${SUDO} iptables -F
${SUDO} iptables -X
${SUDO} iptables -Z
${SUDO} iptables -nvL

#修改SSH为证书登录
${SUDO} sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config

echo "======== set iptables rules================"

# INPUT
${SUDO} iptables -A INPUT -i lo -j ACCEPT
${SUDO} iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
${SUDO} iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${SSH_PORT} -j ACCEPT
${SUDO} iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT
${SUDO} iptables -A INPUT -p tcp -m tcp --dport 443 -j ACCEPT

${SUDO} systemctl restart sshd

${SUDO} iptables -P INPUT DROP
${SUDO} iptables -P FORWARD DROP
${SUDO} iptables -P OUTPUT ACCEPT

${SUDO} iptables-save > /etc/iptables.rules

${SUDO} systemctl enable rc.local
${SUDO} systemctl start rc.local
${SUDO} echo -e "#!/bin/sh -e" | sudo tee /etc/rc.local
${SUDO} echo -e "iptables-restore < /etc/iptables.rules" | sudo tee -a /etc/rc.local
${SUDO} echo -e "exit 0" | sudo tee -a /etc/rc.local
${SUDO} chmod +x /etc/rc.local

${SUDO} iptables -nvL

echo "================= Public IP ====================="
curl https://checkip.amazonaws.com/