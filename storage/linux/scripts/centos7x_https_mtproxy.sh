#!/bin/bash
SSH_PORT=8120
MTPROXY_PORT=5888

echo "========= setting SSH and internat ip and ipsec secrets ======"
echo "please input SSH Port: "
read SSH_PORT
echo "========= SSH Port ============="
echo "${SSH_PORT}"

echo "========= setting SSH and internat ip and ipsec secrets ======"
echo "please input MTProxy Port: "
read MTPROXY_PORT
echo "========= MTProxy Port ============="
echo "${MTPROXY_PORT}"

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -X
iptables -Z

# INPUT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m icmp -p icmp --icmp-type any -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${SSH_PORT} -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport ${MTPROXY_PORT} -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -m state --state NEW -m tcp -p tcp --dport 443 -j ACCEPT

#OUTPUT
iptables -A OUTPUT -o lo -j ACCEPT
iptables -A OUTPUT -m icmp -p icmp --icmp-type any -j ACCEPT

iptables -A OUTPUT -p tcp --sport ${SSH_PORT} -j ACCEPT
iptables -A OUTPUT -p tcp --sport ${MTPROXY_PORT} -j ACCEPT

iptables -A OUTPUT -p tcp --dport 8888 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 21 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
iptables -A OUTPUT -p udp --dport 123 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 443 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 80 -j ACCEPT
iptables -A OUTPUT -p tcp --sport 443 -j ACCEPT

iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

service iptables save
service iptables restart
iptables -nvL

systemctl restart sshd.service
systemctl status sshd.service