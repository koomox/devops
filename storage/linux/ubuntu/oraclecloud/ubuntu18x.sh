#!/bin/bash
echo "========= ubuntu update =============="
apt update -y
apt upgrade -y
apt install curl wget git vim sudo htop net-tools neofetch lsb-release build-essential python iputils-ping -y
apt autoremove -y

echo "======= setting iptables rules =========="
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
iptables -Z
iptables -nvL
iptables-save > /etc/iptables.rules

echo '#!/bin/sh -e' > /etc/rc.local
echo 'iptables-restore < /etc/iptables.rules' >> /etc/rc.local
echo 'exit 0' >> /etc/rc.local
chmod +x /etc/rc.local
iptables -nvL

systemctl restart sshd
systemctl status sshd

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

sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config
sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config
grep -E "^#*(Port|PermitEmptyPasswords|PermitRootLogin|PasswordAuthentication|PubkeyAuthentication)" /etc/ssh/sshd_config

echo "========= setting rc-local ============"
echo -e "\n[Install]\nWantedBy=multi-user.target\nAlias=rc.local.service" >> /lib/systemd/system/rc-local.service
systemctl daemon-reload
systemctl enable rc.local
systemctl start rc.local
systemctl status rc.local

cat /etc/iptables.rules
cat /etc/rc.local