#!/bin/bash
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
sed -E -i '/^#*Port /cPort '"$SSH_PORT"'' /etc/ssh/sshd_config
sed -E -i '/^#*PermitEmptyPasswords/cPermitEmptyPasswords no' /etc/ssh/sshd_config
sed -E -i '/^#*PermitRootLogin/cPermitRootLogin yes' /etc/ssh/sshd_config
sed -E -i '/^#*PasswordAuthentication/cPasswordAuthentication no' /etc/ssh/sshd_config
sed -E -i '/^#*PubkeyAuthentication/cPubkeyAuthentication yes' /etc/ssh/sshd_config

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