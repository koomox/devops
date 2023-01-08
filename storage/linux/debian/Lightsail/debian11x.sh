#!/bin/bash
if [ "$(whoami)" != "root" ]; then
    SUDO=sudo
fi

echo "===== Update System ===================="
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
${SUDO} timedatectl set-timezone Asia/Singapore
timedatectl

echo "===== Custom SSH Port And Iptabes Rules ========="
echo "Input SSH Port: "
read SSH_PORT
echo "Input SSH Key:"
read SSH_KEY
echo "SSH Port: ${SSH_PORT}"
echo "========= SSH Key ============="
echo "${SSH_KEY}"

if [ ! -x "~/.ssh" ];then
	mkdir -p ~/.ssh
fi
echo -e "${SSH_KEY}" > ~/.ssh/authorized_keys
echo "====== read ~/.ssh/authorized_keys ========"
cat ~/.ssh/authorized_keys

#修改SSH为证书登录
${SUDO} sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
${SUDO} sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config

echo "======== set iptables rules================"

# INPUT
${SUDO} nft flush ruleset
${SUDO} nft add table inet filter
${SUDO} nft add chain inet filter input { type filter hook input priority 0\; policy accept\; }
${SUDO} nft add chain inet filter forward { type filter hook forward priority 0\; policy accept\; }
${SUDO} nft add chain inet filter output { type filter hook output priority 0\; policy accept\; }
${SUDO} nft add rule inet filter input ct state invalid drop
${SUDO} nft add rule inet filter input meta iif lo ct state new accept
${SUDO} nft add rule inet filter input ct state established,related accept
${SUDO} nft add rule inet filter input tcp dport ${SSH_PORT} accept
${SUDO} nft add rule inet filter input tcp dport 80 accept
${SUDO} nft add rule inet filter input tcp dport 443 accept
${SUDO} nft add chain inet filter input { type filter hook input priority 0\; policy drop\; }
${SUDO} nft add chain inet filter forward { type filter hook forward priority 0\; policy drop\; }
${SUDO} nft list ruleset

${SUDO} echo -e "flush ruleset" | sudo tee /etc/nftables.conf
${SUDO} echo -e "nft list ruleset" | sudo tee -a /etc/nftables.conf
${SUDO} nft --check --file /etc/nftables.conf
${SUDO} systemctl enable nftables
${SUDO} systemctl start nftables
${SUDO} systemctl status nftables

echo "================= Public IP ====================="
curl https://checkip.amazonaws.com/