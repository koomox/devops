#!/bin/bash
SSH_PORT=22

echo "========= setting SSH and internat ip and ipsec secrets ======"
echo "please input SSH PORT: "
read SSH_PORT
echo "========= SSH PORT ============="
echo "${SSH_PORT}"

echo "===== reset iptables rules======"
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
iptables -F
iptables -X
iptables -Z
service iptables save
service iptables restart
iptables -nvL

# INPUT
iptables -A INPUT -i lo -j ACCEPT
# iptables -A INPUT -m icmp -p icmp --icmp-type any -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${SSH_PORT} -j ACCEPT
iptables -A INPUT -m state --state NEW -m udp -p udp --sport 123 -j ACCEPT
iptables -A INPUT -p tcp --sport 16630 -j ACCEPT

# OUTPUT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m icmp -p icmp --icmp-type any -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A OUTPUT -p tcp --sport ${SSH_PORT} -j ACCEPT

iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 1080 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5222 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5228 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5229 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 5230 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 8080 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 14000 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 16630 -j ACCEPT

### Outlook.com
iptables -A OUTPUT -p tcp --dport 993 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 587 -j ACCEPT

### gmail
iptables -A OUTPUT -p tcp --dport 995 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 465 -j ACCEPT

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP


service iptables save
service iptables restart
iptables -nvL

systemctl restart sshd.service
systemctl status sshd.service